##### SCRIPT PARA ORGANIZAR AS DEPENDENCIAS NECESSARIOS PARA RODAR 
##### ROTINA DE MINERACAO DE DADOS

# pacotes necessarios


if (!'devtools' %in% installed.packages()) install.packages('devtools')
if (!'mongolite' %in% installed.packages()) install.packages('mongolite')
if (!'tidyverse' %in% installed.packages()) install.packages('tidyverse')
if (!'remotes' %in% installed.packages()) install.packages('remotes')
if (!'abjutils' %in% installed.packages()) remotes::install_github("abjur/abjutils")
if (!'rvest' %in% installed.packages()) install.packages('rvest')
if (!'xml2' %in% installed.packages()) install.packages('xml2')
if (!'tesseract' %in% installed.packages()) install.packages('tesseract')
if (!'plumber' %in% installed.packages()) install.packages('plumber')
if (!'webshot' %in% installed.packages()) install.packages('webshot')

library(devtools)
library(mongolite)
library(tidyverse)
library(abjutils)
library(rvest)
library(xml2)
library(plumber)
library(tesseract)

source("R/b3_functions.R", encoding = "UTF-8")
source("R/connections.R", encoding = "UTF-8")

# supress warning in this script

options(warn = -1)
