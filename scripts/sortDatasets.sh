#!/bin/bash

. ./configFile

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
    dump="${datasetsPath}/${f}.nq"
    n=`wc -l ${dump} | sed 's/^[ ^t]*//' | cut -d' ' -f1`
    java orderDataset ${dump} ${n} ${subj} > ${fedBenchDataPath}/${f}${s}.n3
    sed -i -E "s/(<.+>)\s(<.+>)\s(.+)\s(<.+>)\s(\.)/\1 \2 \3\5/" ${fedBenchDataPath}/${f}${s}.n3
done
