library(plumber)

#* @apiTitle Data Mining
#* @apiDescription API para consulta de dados minerados na origem. <br>
#* Para integração com o Data Miner, incluir um endpoint para cada ingestão <br>
#* em cada endpoint, incluir 4 retornos: <br>
#* 1. data do ultimo registro; <br>
#* 2. ultimo registro (nao precisa ser uma unica linha) <br>
#* 3. consenso (com a data referencia desse consenso); <br>
#* 4. base histórica;

#* @apiTag B3 origem de dados B3

#* Buscar Ultima data de atualização da posição dos investidores em mercado a vista
#* @tag B3
#* @serializer json
#* @get /b3/mercado_a_vista/last_date
function() {
  
  extrairUltAtualizacao.b3_a_vista()
    
}

#* Buscar ultimo registro da posição dos investidores em mercado a vista
#* @tag B3
#* @serializer json
#* @get /b3/mercado_a_vista/last
function() {
  
  extrairRegistro.b3_a_vista(output = "last")
    
}

#* Buscar historico da posição dos investidores em mercado a vista
#* @tag B3
#* @serializer json
#* @get /b3/mercado_a_vista/all
function() {
  
  extrairRegistro.b3_a_vista(output = "historical")
    
}


#* Buscar Ultima data de atualização b3 open interest
#* @tag B3
#* @serializer json
#* @get /b3/open_interest/last_date
function() {
  
  extrairUltAtualizacao.b3_open_interest()
    
}

#* Buscar ultimo registro b3 open interest 
#* @tag B3
#* @serializer json
#* @get /b3/open_interest/last
function() {
  
  extrairRegistro.b3_open_interest(output = "last")
    
}

#* Buscar historico open interest
#* @tag B3
#* @serializer json
#* @get /b3/open_interest/all

function() {
  
  extrairRegistro.b3_open_interest(output = "historical")
    
}
#* Buscar Ultima data de atualização da posição dos investidores em mercado futuro
#* @tag B3
#* @serializer json
#* @get /b3/mercado_futuro/last_date
function() {
  
  extrairUltAtualizacao.b3_futuro()
    
}

#* Buscar ultimo registro da posição dos investidores em mercado futuro 
#* @tag B3
#* @serializer json
#* @get /b3/mercado_futuro/last
function() {
  
  extrairRegistro.b3_futuro(output = "last")
    
}

#* Buscar historico da posição dos investidores em mercado futuro 
#* @tag B3
#* @serializer json
#* @get /b3/mercado_futuro/all

function() {
  
  extrairRegistro.b3_futuro(output = "historical")
    
}

#* @apiTag BACEN origem de dados Banco Central

#* Buscar Ultima data de atualização do boletim focus
#* @tag BACEN
#* @serializer json
#* @get /bacen/relatorio_focus/last_date
function() {
  
  
    
}

#* Buscar ultimo registro do boletim focus
#* @tag BACEN
#* @serializer json
#* @get /bacen/boletim_focus/last
function() {
  
    
}

#* Buscar historico do boletim focus
#* @tag BACEN
#* @serializer json
#* @get /bacen/boletim_focus/all
function() {
  
    
}

#* @apiTag Sidra origem de dados do IBGE

