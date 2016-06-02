FROM quay.io/keboola/docker-base-r-packages:3.2.5-b
MAINTAINER Marc Raiser <marc@keboola.com>

COPY . /home/

# install packages necessary for shiny-applications in general
RUN Rscript /home/init.R

# run the main script
ENTRYPOINT Rscript /home/main.R