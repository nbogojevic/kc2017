#! /bin/bash
export KUBE_EDITOR="code --wait"
minikube.exe start --memory 6144 --vm-driver hyperv --v=7 --alsologtostderr --hyperv-virtual-switch kubecon

eval $(minikube.exe docker-env --shell bash)
cp /mnt/c/Users/nbogo/.kube/config /home/nenad/.kube/config
sed -i 's/C:\\/\/mnt\/c\//g' /home/nenad/.kube/config
sed -i 's/\\/\//g' /home/nenad/.kube/config
kubectl create namespace secured

helm init
helm install --name prometheus stable/prometheus
pushd kafka-clients && mvn -B install && popd
pushd kafka-operator && mvn -B install && popd
docker build -t nbogojevic/kafka kubernetes-kafka/docker-kafka/
docker build -t nbogojevic/zookeeper kubernetes-kafka/docker-zookeeper/

kubectl apply -f kafka-clients/deploy.yaml
kubectl delete all -l demo=client
kubectl logs $(kubectl get pod -l app=kafka-consumer -o name)
helm install kubernetes-kafka/kafka-cluster --name kafka-cluster

kubectl delete all -l demo=client
kubectl apply -f kafka-clients/sample-topic.yaml

helm upgrade kafka-cluster kubernetes-kafka/kafka-cluster/

helm delete kafka-cluster --purge
helm install kubernetes-kafka/kafka-cluster --name secret-cluster -f kubecon/secured-kafka.yaml --namespace secured
kubectl apply -f kafka-clients/sample-topic.yaml -n secured
kubectl apply -f kafka-clients/deploy-secured.yaml -n secured

