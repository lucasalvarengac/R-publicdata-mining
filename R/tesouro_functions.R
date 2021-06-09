extrairUltRegistro.tesouro_leiloes <- function() {
  
  con <- createConnectionMongoMoverDB("CONTRATOS_SWAP", "leiloes")
    
  r <- con$find(
    query = '{}'
    ,fields = '{"date":"$dataMovimento", "_id":0}'
    ,sort = '{"dataMovimento":-1}'
    ,limit = 1
  )
  
  con$disconnect()
    
  return(r$date)
}

extrairRegistro.tesouro_leiloes <- function(output) {
  
  con <- createConnectionMongoMoverDB("CONTRATOS_SWAP", "leiloes")
  
  pipeline <- paste0(
    '
        [
            {
                "$addFields": {
                    "id_leilao": {
                        "$toString": "$_id"
                    }
                }
            
            },{
                "$project": {
                    "_id": 0, 
                    "id": "$id_leilao",
                    "publico": 1, 
                    "portaria": 1, 
                    "tipo": 1, 
                    "titulo": 1, 
                    "ofertante": 1, 
                    "prazo": 1, 
                    "liquidacao": 1, 
                    "financeiro": 1, 
                    "tx_media": "$taxaMedia", 
                    "tx_corte": "$taxaCorte", 
                    "dt_movimento": "$dataMovimento", 
                    "qtd_aceita": "$quantidadeAceita", 
                    "qtd_ofertada": "$quantidadeOfertada", 
                    "cotacao_media": "$puCotacaoMedia", 
                    "cotacao_corte": "$puCotacaoCorte", 
                    "seg_rodada_qtd_aceita": "$segundaRodadaQuantidadeAceita", 
                    "seg_rodada_qtd_ofertada": "$segundaRodadaQuantidadeOfertada"
                }
            }
        ]
      '
  )
  
  r <- con$aggregate(pipeline = pipeline) %>% 
    bind_rows() %>% 
    mutate(
      financeiro = financeiro * 10^6
      ,dt_movimento = as.Date(dt_movimento)
      ,dt_ingestao = as.character(Sys.time())
    )
  
  if (output == "last") {
    
    r <- r %>% 
      filter(dt_movimento == max(dt_movimento))
    
  }
  
  con$disconnect()
    
  return(r)
}

extrairDic.tesouro_leiloes <- function() {
  
  df <- extrairRegistro.tesouro_leiloes(output = "all")
  
  df <- df %>% 
    distinct(publico, tipo, titulo, liquidacao, dt_movimento)
  
  return(df)
}

extrairData.tesouro_leiloes <- function(output) {
  
  if (output %in% c("last", "all")) {
    
    extrairRegistro.tesouro_leiloes(output)
    
  } else if (output == "last_date") {
    
    extrairUltRegistro.tesouro_leiloes()
    
  } else if (output == "dic") {
    
    extrairDic.tesouro_leiloes() 
    
  }
  
}
