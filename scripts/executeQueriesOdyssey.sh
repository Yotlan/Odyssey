#!/bin/bash

. ./configFile

fedXDescriptionFile=${federationPath}/fedBenchFederation.ttl

sed -i "s,optimize=.*,optimize=false," ${fedXConfigFile}
cold=true
outputFile=${outputFile}

s=`seq 1 11`
l=${queryExtension}
n=${numRuns}
w=${timeoutValue}

mv ${fedXPath}/lib/slf4j-log4j12-1.5.2.jar ${fedXPath}/

for query in ${l}; do
    f=0
    rm -f ${federatedOptimizerPath}/code/cache.db
    for j in `seq 1 ${n}`; do
        cd ${federatedOptimizerPath}/code
        if [ "$cold" = "true" ] && [ -f cache.db ]; then
            rm -f cache.db
        fi
        /usr/bin/time -f "%e %P %t %M" timeout ${w}s java -Xmx4096m -cp .:${JENA_HOME}/lib/*:${fedXPath}/lib/* evaluateSPARQLQuery ${queryFolder}/$query ${federationFile} ${fedBenchDataPath} 100000000 true false ${fedXConfigFile} ${fedXDescriptionFile} > ${outputFile}
    done
done

mv ${fedXPath}/slf4j-log4j12-1.5.2.jar ${fedXPath}/lib/
cat ${outputFile}
#cat ${errorFile} 
