FROM rocker/shiny:latest

RUN install2.r --error --skipinstalled \
    ggplot2 \
    DT \
    rsconnect

COPY app.R /srv/shiny-server/app.R

RUN rm -rf /srv/shiny-server/sample-apps /srv/shiny-server/index.html

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
