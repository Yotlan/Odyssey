#!/bin/bash

. ./configFile

# maximum number of lines per file to sort
m=5000000

# sorted by subject?
subj=true
datasets=`ls ${federatedOptimizerPath}/fedbench | awk -e '$0 ~ /^(vendor|ratingsite)[0-9]+_void.n3$/ {print}' | cut -d'_' -f 1`

cd ${federatedOptimizerPath}/code

if [ "$subj" = "true" ]; then
   s=Sorted
else 
   s=ObjSorted
fi 

for d in ${datasets}; do
    f=`echo "$d" | tr '[:upper:]' '[:lower:]'`
    dump="${fedBenchDataPath}/${f}_void.n3"

    n=`wc -l ${dump} | sed 's/^[ ^t]*//' | cut -d' ' -f1`
    if [ "$n" -gt "$m" ]; then
        accFile=`mktemp`
        tmpFile=`mktemp`
        split -l $m ${dump} tmp${d}
        for g in `ls tmp${d}*`; do
            t=`wc -l ${g} | sed 's/^[ ^t]*//' | cut -d' ' -f1`
            java orderDataset ${g} ${t} ${subj} > ${g}_sorted
            rm ${g}
        done
        started=0
        for g in `ls tmp${d}*_sorted`; do
            if [ "$started" -gt "0" ]; then
                java mergeDataset ${accFile} ${g} ${subj} > ${tmpFile}
                mv ${tmpFile} ${accFile}
                rm ${g}
            else 
                mv ${g} ${accFile}
                started=1
            fi  
        done
        mv  ${accFile} ${fedBenchDataPath}/${f}${s}.n3
    else 
        java orderDataset ${dump} ${n} ${subj} > ${fedBenchDataPath}/${f}${s}.n3
    fi
done

