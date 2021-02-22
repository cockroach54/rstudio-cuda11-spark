Renviron=/usr/local/lib/R/etc/Renviron

echo "" >> $Renviron
echo "### for gpu and hdfs, spark" >> $Renviron
echo JAVA_HOME=${JAVA_HOME} >> $Renviron
echo CUDA_HOME=${CUDA_HOME} >> $Renviron
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH} >> $Renviron
echo RETICULATE_PYTHON=${RETICULATE_PYTHON} >> $Renviron
echo TENSORFLOW_PYTHON=${TENSORFLOW_PYTHON} >> $Renviron
echo SPARK_DRIVER_PORT=${SPARK_DRIVER_PORT} >> $Renviron
echo "" >> $Renviron
echo "" >> $Renviron