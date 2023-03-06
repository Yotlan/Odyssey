#!/bin/bash

cd fedbench

echo Clean...
rm *_reduced*
rm *Sorted.n3
rm statistics*

cd ../scripts

. ./configFile

echo Compile...
bash compileAll.sh

echo Sort datasets...
bash sortDatasets.sh

echo Generate statistics...
bash generateStatistics.sh

cd ..