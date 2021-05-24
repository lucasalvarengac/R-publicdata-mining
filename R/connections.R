conectMongoDataMining <- function(dbname = "data-mining", collection = "source_ingestion") {
  
  # create connection with mongo
  con <- mongolite::mongo(
    url = 'mongodb://10.158.0.61:27017/?readPreference=primary&appname=MongoDB%20Compass&ssl=false'
    ,db = dbname
    ,collection = collection
  )
  
  return(con)
  
}

createConnectionMongoMoverDB <- function(collection, dbname) {
  
  # create connection with mongo
  con <- mongolite::mongo(
    url = "mongodb://10.158.0.66:27017/"
    ,db = dbname
    ,collection = collection
  )
  
  return(con)
}
