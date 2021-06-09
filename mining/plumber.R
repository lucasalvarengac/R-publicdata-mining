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

#* Base de dados da B3 para posição de investidores no mercado futuro
#* @tag B3
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /b3/mercado_futuro/
function(output) {
  
  extrairData.b3_futuro(output)
    
}

#* Base de dados da B3 para posição de investidores em mercado a vista
#* @tag B3
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /b3/mercado_a_vista/
function(output) {
  
  extrairData.b3_a_vista(output)
    
}

#* Base de dados da B3 para posição de investidores em derivativos 
#* @tag B3
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /b3/open_interest/
function(output) {
  
  extrairData.b3_open_interest(output)
    
}

#* Base de dados da B3 para posição em opcoes
#* @tag B3
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /b3/opcoes/
function(output) {
  
  extrairData.b3_opcoes(output)
    
}

#* @apiTag Sidra origem de dados do IBGE

#* Base Sidra - Pesquisa mensal de emprego (PME)
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pme/
function(output) {
  
  extrairData.sidra_pme(output)
  
}

#* Base Sidra - Pesquisa mensal do emprego ampliado (PME-a)
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pmea/
function(output) {
  
  extrairData.sidra_pmea(output)
  
}

#* Base Sidra - Pesquisa Mensal da Indústria
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pmi/
function(output) {
  
  extrairData.sidra_pmi(output)
  
}

#* Base Sidra - IPCA 15
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/ipca15/
function(output) {
  
  extrairData.sidra_ipca15(output)
  
}

#* Base Sidra - IPCA
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/ipca/
function(output) {
  
  extrairData.sidra_ipca(output)
  
}

#* Base Sidra - PNAD Desemprego
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pnad_desemprego/
function(output) {
  
  extrairData.sidra_pnadc_desemprego(output)
  
}

#* Base Sidra - PNAD Mensal Emprego
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pnad_mensal_emprego/
function(output) {
  
  extrairData.sidra_pnadc_mensal_emprego(output)
  
}

#* Base Sidra - PIB
#* @tag Sidra
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /sidra/pib/
function(output) {
  
  extrairData.sidra_pib(output)
  
}

#* @apiTag Tesouro dados do tesouro

#* @tag Tesouro
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /tesouro/leiloes/
function(output) {
  
  extrairData.tesouro_leiloes(output)
  
}

#* @apiTag Anfavea produção de veículos

#* @tag Anfavea
#* @serializer json
#* @param output selecione o tipo de output desejado (last, all, last_date, dic)
#* @get /anfavea/prod_veiculos/
function(output) {
  
  extrairData.anfavea_prod_veiculos(output)
  
}
