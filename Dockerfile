# use r-base from cran
FROM r-base

# install linux packages needed to run plumber
RUN apt-get update && \
  apt-get install -y libssl-dev libxml2-dev libcurl4-openssl-dev \
  libsodium-dev libmariadb-dev build-essential libmagick++-dev \
  libopenjp2-7-dev libgdk-pixbuf2.0-dev libtesseract-dev \
  libfreetype6-dev libpoppler-cpp-dev libgit2-dev libsasl2-dev \
  libleptonica-dev libcurl4-openssl-dev
  
  

# config locale to pt_BR
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

#RUN sed -i -e 's/# pt_BR.UTF-8 pt_BR.UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
#    dpkg-reconfigure --frontend=noninteractive locales && \
#    update-locale LANG=pt_BR.UTF-8

ENV LANG pt_BR.UTF-8

# install R packages
RUN R -e "install.packages(\
  c(\
    'tidyverse','cowplot','plumber','devtools','scales','plotly',\
    'RMySQL','magick','sysfonts','gridExtra', 'zoo', 'tesseract',\
    'mongolite', 'abjutils', 'rvest', 'xml2', 'tesseract', 'devtools'\
  )\
  ,dependencies=TRUE, repos='http://cran.rstudio.com/')" 

# include files in container
ADD . .

# expose port 9600 of container
EXPOSE 9600

# when initialized start a plumber with this script
CMD ["Rscript", "runApi.R"]  
