To successfully build the eurostat package, this is what I had to do on a fresh Ubuntu 16.04 install:

sudo apt-get install r-base
sudo apt-get install libjpeg62
# download & install rstudio
sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
sudo dpkg -i rstudio-1.0.143-amd64.deb 

# to build eurostat:
sudo apt-get install latex
sudo apt-get install texlive
sudo apt-get install texlive-fonts-extra
# to build eurostatasyl:
sudo apt-get install libxml2
sudo apt-get install libxml2-dev
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install libssl-dev
sudo apt-get install libcairo2
sudo apt-get install libcairo2-dev


