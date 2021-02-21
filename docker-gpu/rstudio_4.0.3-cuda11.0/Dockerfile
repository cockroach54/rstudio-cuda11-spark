FROM lsw-r-ver:cuda11.0

# LABEL org.label-schema.license="GPL-2.0" \
#       org.label-schema.vcs-url="https://github.com/rocker-org/rocker-versioned" \
#       org.label-schema.vendor="Rocker Project" \
#       maintainer="Carl Boettiger <cboettig@ropensci.org>"

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=latest
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

# build cmake
COPY cmake-3.19.5-Linux-x86_64.sh /
RUN mkdir /usr/local/cmake &&\
    chmod 777 cmake-3.19.5-Linux-x86_64.sh &&\
    sh /cmake-3.19.5-Linux-x86_64.sh --skip-license --prefix=/usr/local/cmake &&\
    rm /cmake-3.19.5-Linux-x86_64.sh &&\
    ln -s /usr/local/cmake/bin/cmake /usr/local/bin/cmake


EXPOSE 8787

CMD ["/init"]