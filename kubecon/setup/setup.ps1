$env:KUBE_EDITOR="code --wait"

cd \kubecon
minikube start --memory 4096 --vm-driver hyperv --v=7 --alsologtostderr --hyperv-virtual-switch kubecon
& minikube docker-env | Invoke-Expression
eval $(minikube docker-env)
export KUBE_EDITOR="code --wait"
helm init
pushd kafka-operator
mvn install
popd
pushd kafka-clients
mvn install
popd
kubectl apply -f kafka-clients/deploy.yaml
kubectl logs $(kubectl get pod -l app=kafka-consumer -o name)
kubectl delete pod -l demo=client
kubectl apply -f kafka-clients/sample-map.yaml

$env:KUBE_EDITOR="code --wait"

& minikube docker-env | Invoke-Expression
Push-Location  d:\dev\kafka-operator
mvn clean install
mvn "-Ddocker.username=nbogojevic" "-Ddocker.password=dokerdoker" fabric8:push
Pop-Location

helm init

Set-Location d:\dev\openshift-kafka
helm lint d:\dev\openshift-kafka\kafka-cluster
helm install d:\dev\openshift-kafka\kafka-cluster --name kafka-cluster
helm upgrade kafka-cluster d:\dev\openshift-kafka\kafka-cluster
helm delete kafka-cluster --purge --timeout 10 --debug
helm install --name prometheus stable/prometheus
helm install stable/prometheus --name prometheus --set server.ingress.enabled=true

Push-Location  d:\dev\openshift-kafka
docker login -u nbogojevic -p dokerdoker
docker build -t nbogojevic/kafka d:\dev\openshift-kafka\docker-kafka\
docker build -t nbogojevic/zookeeper d:\dev\openshift-kafka\docker-zookeeper\
docker push nbogojevic/kafka
docker push nbogojevic/zookeeper
Pop-Location
