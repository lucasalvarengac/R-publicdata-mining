extrairRelatorioFocusPdfToDF <- function(url_pdf) {
  
  ocr_text <- pdftools::pdf_ocr_text(url_pdf, pages = 1, language = "por")
  
  dt_relatorio <- unique(stringr::str_extract(ocr_text, "\\d{1,2} de \\w+"))
  
  dt_relatorio2 <- as.Date(dt_relatorio, format = "%d de %B")
  
  values_rows <- stringr::str_split(ocr_text, "\n")
  
  values_rows2 <- unlist(values_rows)[grepl("^meta|^ipca|^pib|^taxa", unlist(values_rows), TRUE)]
  
  values_rows2 <- stringr::str_remove_all(values_rows2, "\\(\\d+\\) ")
  
  values_rows2 <- values_rows2[grepl("\\d{1,2}\\,?\\d{1,2}", values_rows2)]
  
  labels <- paste0(stringr::str_trim(stringr::str_extract_all(values_rows2, "^[^\\)]+"), "both"), ")")
  values <- unlist (stringr::str_extract_all(values_rows2, "\\d{1,2}\\,?\\d{1,2}"))
  
  cbind(labels, matrix(values, ncol = 16, byrow = TRUE)) %>% 
    as.data.frame() %>% 
    tidyr::pivot_longer(
      cols = 2:ncol(.)
    ) %>% 
    mutate(
      var_num = as.numeric(stringr::str_extract(name, "\\d+$"))
      ,ano = case_when(
        var_num %in% 2:5 ~ format(Sys.Date(), format = "%Y")
        ,var_num %in% 6:9 ~ format(Sys.Date() + lubridate::years(1), format = "%Y")
        ,var_num %in% 10:13 ~ format(Sys.Date() + lubridate::years(2), format = "%Y")
        ,var_num %in% 14:17 ~ format(Sys.Date() + lubridate::years(3), format = "%Y")
      )
      ,variavel = case_when(
        var_num %in% c(2, 6, 10, 14) ~ "mes"
        ,var_num %in% c(3, 7, 11, 15) ~ "semana"
        ,var_num %in% c(4, 8, 12, 16) ~ "hoje"
        ,var_num %in% c(5, 9, 13, 17) ~ "respondentes"
      )
      ,value = as.numeric(gsub("\\,", "", value))
      ,value = ifelse(
        variavel != "respondentes"
        ,round(value / 100,2)
        ,value
      )
      ,dt_relatorio = dt_relatorio2
      ,dt_ingestao = as.character(as.POSIXct(Sys.time()))
    ) %>% 
    select(
      dt_relatorio
      ,ano_projecao = ano
      ,var = labels
      ,dt_var = variavel
      ,valor = value
      ,dt_ingestao
    ) %>% 
    tidyr::pivot_wider(
      id_cols = c(dt_relatorio, var, dt_ingestao, ano_projecao)
      ,values_from = valor
      ,names_from = dt_var
    )
  
}

pegarUltSegunda <- function() {
  
  dia_atual <- Sys.Date()
  
  format(dia_atual, format = "%w")
}

withoutJS <- xml2::read_html("https://www.bcb.gov.br/publicacoes/focus") %>%
  rvest::html_nodes(".avb-item") %>%
  rvest::html_text()

library(rvest)

# render HTML from the site with phantomjs

url <- "https://www.bcb.gov.br/publicacoes/focus"

writeLines(
  sprintf("var page = require('webpage').create();
  page.open('%s', function () {
      console.log(page.content); //page source
      phantom.exit();
  });", url), con="scrape.js"
)

system("phantomjs scrape.js > scrape.html", intern = T)

# extract the content you need
pg <- html("scrape.html")
pg %>% html_nodes("#utime") %>% html_text()


extrairUltAtualizacao.boletim_focus <- function() {
  
  url <- "https://www.bcb.gov.br/publicacoes/focus"
  
  html <- httr::GET(
    url = url
  )
  
  httr::content(html) %>% 
    rvest::html_text()
  
  html_text <- rawToChar(html$content)
    
  stringr::str_extract(html_text, "\\d{2}\\/\\d{2}\\/\\d{4}")
    
  
  
}

extrairRegistro.boletim_focus <- function() {
  
}

extrairConsenso.boletim_focus <- function() {
  
}

extrairUltAtualizacao.b3_futuro <- function() {
  
  # data <- format(data, format = "%d/%m/%Y")
  
  # data = "19/04/2021"
  
  # url to mining data from b3 future contracts
  url <- "https://www.bcb.gov.br/publicacoes/focus"
  
  # create a session to pass parameters in extraction
  session <- rvest::html_session(url)
  
  # extract form from session
  form <- html_form(session)
  
  # set date value to form
  # form <- set_values(form[[1]], dData1 = data)
  
  # submit the form
  # form_res_cbs <- submit_form(session, form)
  
  # extract generated tables in form
  html_tables <- rvest::html_nodes(session, xpath = '/html/body/div[1]/div[2]/div') %>% 
    html_nodes("table")
  
  # if date has no values, return null
  if (length(html_tables) == 0) {
    
    print(sprintf("dados nao existe na origem (%s)", data))
    
    return(NULL)
    
  }
  
  # converting last update string to proper date format
  dt_ult_atualizacao <- as.Date(data, format = "%d/%m/%Y")
  
  # print date to be updated
  print(sprintf("extraindo dados (%s) ...", data))
  
  # iterating over tables extracted from forms
  
  l <- lapply(1:length(html_tables), function(i, dt_ult_atualizacao) {
    
    extrairTabB3(tb_html = html_tables[i], dt_ult_atualizacao = dt_ult_atualizacao)
    
  }, dt_ult_atualizacao = dt_ult_atualizacao) %>% 
    bind_rows() %>% 
    mutate(
      contratos = as.numeric(contratos)
      ,dt_atualizacao = as.Date(dt_atualizacao)
      ,perc = as.numeric(perc)
    )
  
  # converting to non accents encoding
  l$nome_contrato <- iconv(l$nome_contrato, "UTF-8", "ASCII//TRANSLIT")
  
  # converting to non accents encoding
  l$tipo_investidor <- iconv(l$tipo_investidor, "UTF-8", "ASCII//TRANSLIT")
  
  return(l)
    
}