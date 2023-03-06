#!/bin/bash

. ./configFile

finished=""

toDo=`ls ${federatedOptimizerPath}/fedbench | awk -e '$0 ~ /^(vendor|ratingsite)[0-9]+_void.n3$/ {print}' | cut -d'_' -f 1`
folder=${fedBenchDataPath}

cd ${federatedOptimizerPath}/code

for d in ${toDo}; do
    java changeCPS ${folder}/statistics${d}_cps_obj_reduced10000CS ${folder}/statistics${d}_cps_obj_reduced10000CS_old 
    java changeCPS ${folder}/statistics${d}_cps_reduced10000CS ${folder}/statistics${d}_cps_reduced10000CS_old
    java changeCPS ${folder}/statistics${d}_cps_subj_obj_reduced10000CS ${folder}/statistics${d}_cps_subj_obj_reduced10000CS_old

    for e in ${finished}; do
        java changeCPS ${folder}/cps_${d}_${e}_obj_reduced10000CS_MIP  ${folder}/cps_${d}_${e}_obj_reduced10000CS_MIP_old
        java changeCPS ${folder}/cps_${d}_${e}_reduced10000CS_MIP ${folder}/cps_${d}_${e}_reduced10000CS_MIP_old
        java changeCPS ${folder}/cps_${d}_${e}_subj_obj_reduced10000CS_MIP ${folder}/cps_${d}_${e}_subj_obj_reduced10000CS_MIP_old
        java changeCPS ${folder}/cps_${e}_${d}_obj_reduced10000CS_MIP  ${folder}/cps_${e}_${d}_obj_reduced10000CS_MIP_old
        java changeCPS ${folder}/cps_${e}_${d}_reduced10000CS_MIP ${folder}/cps_${e}_${d}_reduced10000CS_MIP_old
        java changeCPS ${folder}/cps_${e}_${d}_subj_obj_reduced10000CS_MIP ${folder}/cps_${e}_${d}_subj_obj_reduced10000CS_MIP_old
    done
    finished=`echo "${finished} ${d}"`
    echo "finished with ${d}"
done
