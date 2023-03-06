. ./configFile

cd ${federatedOptimizerPath}/code
rm -rf *.class || true
javac -cp .:${JENA_HOME}/lib/*:${fedXPath}/lib/* *.java

cd ${federatedOptimizerPath}/proxy
rm -rf *.class || true
javac -cp .:${httpcomponentsClientPath}/lib/* SingleEndpointProxy2.java
