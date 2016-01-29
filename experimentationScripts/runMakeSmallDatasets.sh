#!/bin/sh
for i in $(seq 14 31);
    do matlab -nojvm -nodisplay -nosplash -r "ii = $i; makeSmallDatasets" | tee -a scaleLog.txt;
done
