FROM lsw-base:cuda11.0

# LABEL org.label-schema.license="GPL-2.0" \
#       org.label-schema.vcs-url="https://github.com/rocker-org/rocker-versioned" \
#       org.label-schema.vendor="Rocker Project" \
#       maintainer="Carl Boettiger <cboettig@ropensci.org>"

ENV R_VERSION=4.0.3
ENV TERM=xterm
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV R_HOME=/usr/local/lib/R
ENV CRAN=https://packagemanager.rstudio.com/all/__linux__/focal/latest
ENV TZ=Etc/UTC

COPY scripts /rocker_scripts

# 여기서 쿠다 nvcc등 사라짐
RUN /rocker_scripts/install_R.sh 

# 쿠다 디렉토리 복원 (임시)
ADD cuda11.tar.gz /usr/local
RUN /rocker_scripts/config_R_cuda.sh

CMD ["R"]
