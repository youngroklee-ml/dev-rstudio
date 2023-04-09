FROM rocker/r-ver:4.2.2

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2022.12.0+353
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    zlib1g-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install git
RUN apt-get -y install git

# Set cache path
RUN echo "RENV_PATHS_CACHE=/renv/cache" >> /usr/local/lib/R/etc/Renviron

# Install renv
RUN install2.r -e renv


# install required library to compile systemfonts package which is a part of devtools package
RUN apt-get update && apt-get install -y libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# install required library to compile textshaping package which is a part of devtools package
RUN apt-get update && apt-get install -y libharfbuzz-dev libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# install required library to compile rang package which is a part of devtools package
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev  \
    && rm -rf /var/lib/apt/lists/*

# install required library to compile gert package which is a part of devtools package
RUN apt-get update && apt-get install -y libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Disabling the authentication step
ENV DISABLE_AUTH=true

EXPOSE 8787

CMD ["/init"]
