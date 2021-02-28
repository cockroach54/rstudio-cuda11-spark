
#!/bin/sh

if [ "$1" == "gpu" ]; then 
  # gpu ver
  docker exec -it rstudio-test-gpu bash
else
  # cpu ver
  docker exec -it rstudio-test bash
fi