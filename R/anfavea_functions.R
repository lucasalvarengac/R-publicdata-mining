library(httr)
library(rvest)

extrairRegistro.anfavea_prod_veiculos <- function(output) {
  
  if (output == "last") {
    
    ano <- format(Sys.Date(), format = "%Y")
    
  } else {
    
    ano <- as.character(2018:as.numeric(format(Sys.Date(), format = "%Y")))
    
  }
  
  l <- lapply(ano, function(x) {
    
    print(sprintf("começando o ano %s ...", x))
    
    r <- openxlsx::read.xlsx(
      xlsxFile = paste0("https://www.anfavea.com.br/docs/siteautoveiculos", x,".xlsx")
      ,sheet = 7
      ,startRow = 7
    )
    
    r[,1] <- zoo::na.locf(r[,1])
    r[,2] <- ifelse(is.na(r[,2]), "total", r[,2])
    
    date_cols <- as.character(seq(
      from = as.Date(paste0(x, "-01-01"))
      ,to = as.Date(paste0(x, "-12-01"))
      ,by = "months"
    ))
    
    r <- r[,-ncol(r)]
    
    names(r) <- c("tipo", "detalhe", date_cols)
    
    tidyr::pivot_longer(
      data = r
      ,cols = 3:ncol(r)
      ,names_to = "date"
      ,values_to = "valor"
    ) %>% 
      filter(
        date != "total_ano"
        ,valor > 0
      ) 
  }) %>% 
    bind_rows()
  
  if (output == "last") {
    
    l <- l %>% 
      filter(date == max(date))
    
  }
  
  return(l)
}

extrairUltRegistro.anfavea_prod_veiculos <- function() {
  
  df <- extrairRegistro.anfavea_prod_veiculos("last")
  
  return(unique(df$date))
  
}

extrairDic.anfavea_prod_veiculos <- function() {
  
  df <- extrairRegistro.anfavea_prod_veiculos("all")
  
  df <- df %>% 
    distinct(tipo, detalhe, date)
  
  return(df)
  
}

extrairData.anfavea_prod_veiculos <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.anfavea_prod_veiculos(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.anfavea_prod_veiculos()
    
  } else if (output == "dic") {
    
    extrairDic.anfavea_prod_veiculos() 
    
  }
  
}
