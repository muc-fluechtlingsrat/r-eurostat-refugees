# Installation to get eurostat working in rstudio

To successfully build the eurostat package, this is what I had to do on a fresh Ubuntu 16.04 install:

    sudo apt-get install r-base
    sudo apt-get install libjpeg62
### download & install rstudio
    from https://www.rstudio.com/products/rstudio/download/
    either install with software center, or
    sudo dpkg -i rstudio-1.0.143-amd64.deb 
    
### the eurostat package has a number of dependencies:

    sudo apt-get install texlive
    sudo apt-get install texlive-fonts-extra
    sudo apt-get install libxml2
    sudo apt-get install libxml2-dev
    sudo apt-get install libcurl4-openssl-dev
    sudo apt-get install libssl-dev
    sudo apt-get install libcairo2
    sudo apt-get install libcairo2-dev
    
Now it should be possible in r-studio (or plain R) to run install.packages("eurostat").    
