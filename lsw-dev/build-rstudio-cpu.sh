#!/bin/sh

# bit
# bit64
# arrow 2.0
wget https://cran.r-project.org/src/contrib/Archive/bit/bit_1.1-14.tar.gz
wget https://cran.r-project.org/src/contrib/Archive/bit64/bit64_0.9-7.tar.gz
wget https://cran.r-project.org/src/contrib/Archive/arrow/arrow_2.0.0.tar.gz

R CMD INSTALL bit_1.1-14.tar.gz
R CMD INSTALL bit64_0.9-7.tar.gz
export LIBARROW_BINARY=true
R CMD INSTALL arrow_2.0.0.tar.gz

