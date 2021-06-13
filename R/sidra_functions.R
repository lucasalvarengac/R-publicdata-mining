extractDfSidra <- function(x) {
  
  temp_file <- tempfile()
  
  curl::curl_download(
    url = x
    ,destfile = temp_file
  )
  
  r <- jsonlite::fromJSON(txt = temp_file)
  
  col_names <- unlist(r[1,])
  
  r <- r[2:nrow(r), ]
  
  r <- r[r$MC != "", ]
  
  r$date <- lubridate::ym(r$D3C)
  
  col_names <- unname(unlist(c(col_names, "date", "dt_ingestao")))
  
  r$dt_ingestao <- as.character(as.POSIXct(Sys.time()))
  
  names(r) <- gsub("_$", "", gsub("\\W+", "_", tolower(abjutils::rm_accent(col_names))))
  
  return(r)
}

# pesquisa mensal do emprego (PME)

extrairRegistro.sidra_pme <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3416/n1/all/v/all/p/", output,"/c11046/all/d/v564%201,v565%201")
  )
  
  return(df)
  
}

extrairDic.sidra_pme <- function() {
  
  df <- extractDfSidra(
    x = "https://apisidra.ibge.gov.br/values/t/3416/n1/all/v/all/p/all/c11046/all/d/v564%201,v565%201"
  )
  
  df <- df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairUltRegistro.sidra_pme <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3416/n1/all/v/all/p/last/c11046/all/d/v564%201,v565%201")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairData.sidra_pme <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pme(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pme()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pme()
    
  }
  
}

# pesquisa mensal do emprego ampliado (PME-a)

extrairRegistro.sidra_pmea <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3417/n1/all/v/all/p/", output,"/c11046/all/d/v1186%201,v1190%201")
  )
  
  return(df)
  
}

extrairUltRegistro.sidra_pmea <- function() {
  
  df <- extractDfSidra(
    x = "https://apisidra.ibge.gov.br/values/t/3417/n1/all/v/all/p/last/c11046/all/d/v1186%201,v1190%201"
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairDic.sidra_pmea <- function() {
  
  df <- extractDfSidra(
    x = "https://apisidra.ibge.gov.br/values/t/3417/n1/all/v/all/p/all/c11046/all/d/v1186%201,v1190%201"
  )
  
  df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairData.sidra_pmea <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pmea(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pmea()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pmea()
    
  }
  
}

# ipca15

extrairRegistro.sidra_ipca15 <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3065/n1/all/v/all/p/", output,"/d/v355%202,v356%202,v1117%2013,v1118%202,v1119%202,v1120%202")
  )
  
  return(df)
  
}

extrairDic.sidra_ipca15 <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3065/n1/all/v/all/p/all/d/v355%202,v356%202,v1117%2013,v1118%202,v1119%202,v1120%202")
  )
  
  df <- df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairUltRegistro.sidra_ipca15 <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3065/n1/all/v/all/p/last/d/v355%202,v356%202,v1117%2013,v1118%202,v1119%202,v1120%202")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairData.sidra_ipca15 <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_ipca15(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_ipca15()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_ipca15()
    
  }
  
}

# pnadc pessoal desocupado

extrairRegistro.sidra_pnadc_desemprego <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/1616/n1/all/v/4092/p/", output,"/c1965/40310")
  )
  
  return(df)
  
}

extrairDic.sidra_pnadc_desemprego <- function() {
  
  df <- extrairRegistro.sidra_pnadc_desemprego("all")
  
  df <- df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairUltRegistro.sidra_pnadc_desemprego <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/1616/n1/all/v/4092/p/last/c1965/40310")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairData.sidra_pnadc_desemprego <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pnadc_desemprego(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pnadc_desemprego()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pnadc_desemprego()
    
  }
  
}

# pnadc pessoal ocupado 

extrairRegistro.sidra_pnadc_mensal_emprego <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3918/n1/all/v/all/p/", output,"/c12027/31295/d/v4091%201,v8430%201,v8435%201")
  )
  
  return(df)
  
}

extrairUltRegistro.sidra_pnadc_mensal_emprego <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3918/n1/all/v/all/p/last/c12027/31295/d/v4091%201,v8430%201,v8435%201")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairDic.sidra_pnadc_mensal_emprego <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3918/n1/all/v/all/p/all/c12027/31295/d/v4091%201,v8430%201,v8435%201")
  )
  
  df <- df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairData.sidra_pnadc_mensal_emprego <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pnadc_mensal_emprego(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pnadc_mensal_emprego()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pnadc_mensal_emprego()
    
  }
  
}

# pib

extrairRegistro.sidra_pib <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/1846/n1/all/v/all/p/", output,"/c11255/all/d/v585%200")
  )
  
  return(df)
  
}

extrairUltRegistro.sidra_pib <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/1846/n1/all/v/all/p/last/c11255/all/d/v585%200")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairDic.sidra_pib <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/1846/n1/all/v/all/p/all/c11255/all/d/v585%200")
  )
  
  df <- df %>% 
    distinct(variavel, setores_e_subsetores, date)
  
  return(df)
  
}

extrairData.sidra_pib <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pib(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pib()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pib()
    
  }
  
}

# pesquisa mensal industria

extrairRegistro.sidra_pmi <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3651/n1/all/v/all/p/", output,"/c543/129278,129283,129300,129311/d/v3134%201,v3135%201,v3136%201,v3137%201,v3138%201,v3139%201,v3140%201,v3141%201,v4139%201")
  )
  
  return(df)
  
}

extrairUltRegistro.sidra_pmi <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3651/n1/all/v/all/p/last/c543/129278,129283,129300,129311/d/v3134%201,v3135%201,v3136%201,v3137%201,v3138%201,v3139%201,v3140%201,v3141%201,v4139%201")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairDic.sidra_pmi <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/3651/n1/all/v/all/p/all/c543/129278,129283,129300,129311/d/v3134%201,v3135%201,v3136%201,v3137%201,v3138%201,v3139%201,v3140%201,v3141%201,v4139%201")
  )
  
  df <- df %>% 
    distinct(grandes_categorias_economicas, variavel, date)
  
  return(df)
  
}

extrairData.sidra_pmi <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_pib(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_pib()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_pib()
    
  }
  
}

# ipca

extrairRegistro.sidra_ipca <- function(output) {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/6691/n1/all/v/all/p/", output,"/d/v63%202,v2266%2013,v9798%202,v9800%202")
  )
  
  return(df)
  
}

extrairUltRegistro.sidra_ipca <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/6691/n1/all/v/all/p/last/d/v63%202,v2266%2013,v9798%202,v9800%202")
  )
  
  return(strftime(max(as.Date(r$date)), format = "%Y-%m-%d %H:%M:%S"))
  
}

extrairDic.sidra_ipca <- function() {
  
  df <- extractDfSidra(
    x = paste0("https://apisidra.ibge.gov.br/values/t/6691/n1/all/v/all/p/all/d/v63%202,v2266%2013,v9798%202,v9800%202")
  )
  
  df <- df %>% 
    distinct(variavel, date)
  
  return(df)
  
}

extrairData.sidra_ipca <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.sidra_ipca(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.sidra_ipca()
    
  } else if (output == "dic") {
    
    extrairDic.sidra_ipca()
    
  }
  
}

