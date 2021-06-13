# b3 mercado futuro
# 
extrairUltAtualizacao.b3_futuro <- function() {
  
  # url para requisicao dos dados de posicao em mercado futuro
  url = "http://www2.bmf.com.br/pages/portal/bmfbovespa/lumis/lum-tipo-de-participante-ptBR.asp"
  
  # baixa o html ta pagina
  html <- read_html(url)
  
  # extrai a data da ultima atualizacao
  data_text <- html %>% 
    html_node(xpath = "/html/body/div[1]/div[1]/div/form/div/div[3]/p") %>% 
    html_text() %>% 
    unlist() %>% 
    stringr::str_extract(., "[\\d\\/]+") %>% 
    as.Date(format = "%d/%m/%Y")
    
  if (length(data_text) == 0) return(NULL)
  
  return(unique(strftime(as.Date(data_text), format = "%Y-%m-%d %H:%M:%S")))
  
}

extrairRegistro.b3_futuro <- function(output = "last") {
  
  # function to extract table data from html table returned from forms
  extrairTabB3 <- function(tb_html, dt_ult_atualizacao) {
    
    # extract contract name
    nome_contrato <- html_node(tb_html, "caption") %>% 
      html_text() %>% 
      stringr::str_trim("both")
    
    # extracting rows from html table
    tb_html_rows <- html_node(tb_html, "tbody") %>% 
      html_children()
    
    # structuring data to data.frame format
    l_rows <- lapply(1:length(tb_html_rows), function(j) {
      
      # extract row data
      html_row <- tb_html_rows[j]
      
      # extract text
      text_row <- html_row %>% 
        html_text()
      
      # breaking text with pattern
      tp_investidor <- str_trim(unlist(stringr::str_split(text_row, pattern = "\\r"))[1])
      
      # using regex to extract only value
      text_row <- stringr::str_extract(unlist(stringr::str_split(text_row, pattern = "\\r")), "[\\d\\.\\,]+")
      
      # removing NA's and non number values
      text_row <- text_row[!is.na(text_row) & grepl("\\d+", text_row)]
      
      # check if there are 4 rows to create a data.frame
      if (length(text_row) == 4) {
        
        df_row <- data.frame(
          tipo_investidor = tp_investidor
          ,tp_operacao = c("Compra", "Venda")
          ,contratos = gsub("\\,", "\\.", gsub("\\.", "", c(text_row[1], text_row[3])))
          ,perc = round(as.numeric(gsub("\\,", "\\.", gsub("\\.", "", c(text_row[2], text_row[4])))) / 100, 4)
          ,stringsAsFactors = FALSE
        )
        
        return(df_row)
        
      } else {
        
        sprintf("Sem dados para %s", dt_ult_atualizacao)
        return(NULL)
        
      }
    })
    
    # binding all tables into one
    l_rows2 <- l_rows %>% 
      bind_rows() 
    
    # assign contract name to a column
    l_rows2$nome_contrato <- nome_contrato
    
    # assign the date from the contract extraction
    l_rows2$dt_atualizacao <- dt_ult_atualizacao
    
    return(l_rows2)
  }
  
  extracaoB3ContratosDia <- function(data) {
    
    data <- format(data, format = "%d/%m/%Y")
    
    # data = "19/04/2021"
    
    # url to mining data from b3 future contracts
    url = "http://www2.bmf.com.br/pages/portal/bmfbovespa/lumis/lum-tipo-de-participante-ptBR.asp"
    
    # create a session to pass parameters in extraction
    session <- rvest::html_session(url)
    
    # extract form from session
    form <- html_form(session)
    
    # set date value to form
    form <- set_values(form[[1]], dData1 = data)
    
    # submit the form
    form_res_cbs <- submit_form(session, form)
    
    # extract generated tables in form
    html_tables <- rvest::html_nodes(form_res_cbs, xpath = '/html/body/div[1]/div[2]/div') %>% 
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
  
  if (output == "last") {
    
    df <- extracaoB3ContratosDia(
      data = extrairUltAtualizacao.b3_futuro()
    )
    
  } else if (output == "historical") {
    
    date_seq <- seq(as.Date("2020-01-01"), Sys.Date(), by = "days")
    
    df <- lapply(date_seq, extracaoB3ContratosDia) %>% 
      bind_rows()
    
  }
  
  return(df)
}

extrairDic.b3_futuro <- function() {
  
  r <- extrairRegistro.b3_futuro("last")
  
  distinct(r, tipo_investidor, tp_operacao, nome_contrato) 
}

extrairConsenso.b3_futuro <- function() {
  
  return(NULL)
  
}

extrairData.b3_futuro <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.b3_futuro(output)
    
  } else if (output == "dic") {
    
    extrairDic.b3_futuro()
    
  } else if (output == "last_date") {
    
    extrairUltAtualizacao.b3_futuro()
    
  }
  
}

# b3 mercado a vista
# 
extrairUltAtualizacao.b3_a_vista <- function() {
  
  con <- createConnectionMongoMoverDB(
    collection = "days"
    ,dbname = "b3investors"
  )
  
  r <- con$find("{}")
  
  con$disconnect()
  
  r$date <- r$date + 60*60*3
  
  ult_atualizacao <- as.Date(max(r$date))
  
  return(max(strftime(ult_atualizacao, format = "%Y-%m-%d %H:%M:%S")))
  
}

extrairRegistro.b3_a_vista <- function(output = "last") {
  
  con <- createConnectionMongoMoverDB(
    collection = "days"
    ,dbname = "b3investors"
  )
  
  r <- con$find("{}")
  
  con$disconnect()
  
  r$date <- as.Date(r$date + 60*60*3)
  
  df <- lapply(r[,2:ncol(r)], function(x, date) {
    
    x$date <- date
    
    return(x)
    
  }, r$date) %>% 
    bind_rows()
  
  df_final <- df %>% 
    mutate(
      TypeInvestor = abjutils::rm_accent(df$TypeInvestor)
      ,mes = format(date, format = "%m-%Y")
    ) %>% 
    group_by(
      TypeInvestor, mes
    ) %>% 
    arrange(date) %>% 
    mutate(
      date = as.Date(date)
      ,BalanceVolumeNumVar = ifelse(
        is.na(lag(BalanceVolumeNum,1))
        ,BalanceVolumeNum
        ,BalanceVolumeNum - lag(BalanceVolumeNum,1)
      )
    ) %>% 
    ungroup() %>% 
    select(
      tp_investidor = TypeInvestor
      ,date
      ,balance_var = BalanceVolumeNumVar
    ) %>% 
    filter(
      date != min(date)
    )
  
  if (output == "last") {
    
    df_final <- df_final %>% 
      filter(
        date == max(date)
      )
    
  }
  
  return(df_final)
}

extrairDic.b3_a_vista <- function() {
  
  r <- extrairRegistro.b3_a_vista("last")
  
  distinct(r, tp_investidor)
}

extrairConsenso.b3_a_vista <- function() {
  
  return(NULL)
  
}

extrairData.b3_a_vista <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.b3_a_vista(output)
    
  } else if (output == "dic") {
    
    extrairDic.b3_a_vista()
    
  } else if (output == "last_date") {
    
    extrairUltAtualizacao.b3_a_vista()
    
  }
  
}

# b3 open interest

extrairUltAtualizacao.b3_open_interest <- function() {
  
  con <- createConnectionMongoMoverDB("openinterest", "openinterest")
  
  r <- con$find('{}', fields = '{"date":1, "_id":0}', sort = '{"date":-1}', limit = 1)
  
  r$date <- as.POSIXct(r$date + 10800)
  
  return(strftime(max(r$date), format = "%Y-%m-%d %H:%M:%S"))
}

extrairRegistro.b3_open_interest <- function(output = "all") { 
  
  extrairOpenInterest <- function(dt_filter) {
    
    # dt_filter <- as.Date(Sys.Date()-7)
    
    d <- as.integer(as.POSIXct(strptime(as.character(dt_filter),"%Y-%m-%d"))) - 10800
    
    print(d)
    
    con <- createConnectionMongoMoverDB("openinterest", "openinterest")
    
    r <- con$find(paste0('{"date":{"$gte": { "$date" : { "$numberLong" : "', d, '" } } } }'))
    
    if (nrow(r) == 0) {
      
      return(NULL)
      
    }
    
    l <- lapply(1:length(r$array), function(x) {
      
      df <- r$array[[x]]
      
      df$date <- r$date[x]
      df$total <- r$total[x]
      df$dateString <- r$dateString[x]
      
      return(df)
      
    }) %>% 
      bind_rows() %>% 
      filter(
        Commodity != ''
      ) %>% 
      mutate(
        date = date + 3*60*60
        ,ticker = stringr::str_trim(stringr::str_extract(Commodity, "^[^\\:]+"), "both")
        ,ticker_name = stringr::str_trim(stringr::str_extract(Commodity, "[^\\:]+$"), "both")
        ,`Open Interest` = gsub("\\,+", "", `Open Interest`)
        ,dt_ingestao = as.character(Sys.time())
        ,ticker_name2 = iconv(ticker_name, "UTF-8", "LATIN1")
        ,ticker_name3 = iconv(ticker_name, "LATIN1", "UTF-8")
      ) %>% 
      filter(
        date >= dt_filter
      ) %>% 
      select(
        market = Market
        ,date
        ,ticker
        ,ticker_name
        ,open_interest = `Open Interest`
      )
    
    con$disconnect()
    
    return(l)
  }
  
  dt_ult <- extrairUltAtualizacao.b3_open_interest()
  
  if (output == "all") {
    
    r <- extrairOpenInterest(dt_filter = as.Date("2021-01-01"))
    
  } else { 
    
    r <- extrairOpenInterest(dt_filter = dt_ult)
    
  }
  
  return(r)
}

extrairDic.b3_open_interest <- function() {
  
  r <- extrairRegistro.b3_open_interest("last")
  
  select(
    .data = r
    ,market
    ,ticker
    ,ticker_name
  ) %>% 
    distinct()
  
}

extrairConsenso.b3_open_interest <- function() {
  
  return(NULL)
  
}

extrairData.b3_open_interest <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.b3_open_interest(output)
    
  } else if (output == "dic") {
    
    extrairDic.b3_open_interest()
    
  } else if (output == "last_date") {
    
    extrairUltAtualizacao.b3_open_interest()
    
  }
  
}

# b3 opcoes em aberto

extrairUltAtualizacao.b3_opcoes <- function() {
  
  con <- createConnectionMongoMoverDB("options", "options")
  
  r <- con$find('{}', fields = '{"date":1, "_id":0}', sort = '{"date":-1}', limit = 1)
  
  r$date <- as.POSIXct(r$date + 10800)
  
  return(strftime(max(r$date), format = "%Y-%m-%d %H:%M:%S"))
}

extrairRegistro.b3_opcoes <- function(output = "all") { 
  
  con <- createConnectionMongoMoverDB("options", "options")
  
  if (output == "all") {
    
    pipeline <- paste0(
      '
        [
            {
                "$unwind": {
                    "path": "$items", 
                    "includeArrayIndex": "opcoes", 
                }
            }
        ]    
      '
    )
  } else {
    
    dt_filter <- extrairUltAtualizacao.b3_opcoes()
    
    d <- as.integer(as.POSIXct(strptime(as.character(dt_filter),"%Y-%m-%d"))) * 1000
    
    
    # r <- con$find(paste0('{"date":{"$gte": { "$date" : { "$numberLong" : "', d, '" } } } }'))
    
    pipeline <- paste0(
      '
        [
            {
                "$sort": {
                    "date": -1
                }
            }, {
                "$limit": 1
            }, {
                "$unwind": {
                    "path": "$items", 
                    "includeArrayIndex": "opcoes"
                }
            }
        ]
      '
    )
    
  }
  
  tictoc::tic()
  r <- con$aggregate(pipeline)
  tictoc::toc()
  
  r_final <- bind_rows(r$items) %>% 
    bind_cols(select(r, -items)) %>% 
    select(
      serie = ser
      ,preco_strike = prEx
      ,nome_empresa = nmEmp
      ,posicao_coberta = poCob
      ,posicao_descoberta = posDe
      ,titulares = qtdClTit
      ,posicao_travada = posTr
      ,posicao_total = posTo
      ,qtd_lancadores = qtdClLan
      ,dt_vencimento = dtVen
      ,tp_opcao = tMerc
      ,mercadoria = mer
      ,tp_ativo = espPap
      ,date
    )
    
  return(r_final)
}

extrairDic.b3_opcoes <- function() {
  
  r <- extrairRegistro.b3_opcoes("last")
  
  distinct(r, serie, nome_empresa, tp_ativo)
  
}

extrairData.b3_opcoes <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.b3_opcoes(output)
    
  } else if (output == "dic") {
    
    extrairDic.b3_opcoes()
    
  } else if (output == "last_date") {
    
    extrairUltAtualizacao.b3_opcoes()
    
  }
  
}