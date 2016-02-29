#!/bin/bash
array=( 2 3 5 8 9 10 )
for i in "${array[@]}"
do
    # echo $i
    matlab -nojvm -nodisplay -nosplash -r "ii = $i; makeSmallDatasets" | tee -a scaleLog4.txt;
done
