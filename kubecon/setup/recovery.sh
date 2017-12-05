# Recovery 


kubectl delete pod $(kubectl get pod -l component=kafka-operator -o name)
helm upgrade kafka-cluster kubernetes-kafka/kafka-cluster/

helm delete kafka-cluster --purge
helm install kubernetes-kafka/kafka-cluster --name secret-cluster -f kubecon/secured-kafka.yaml --namespace secured
kubectl apply -f kafka-clients/sample-topic.yaml -n secured
kubectl apply -f kafka-clients/deploy-secured.yaml -n secured
