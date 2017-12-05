# Deploy clients
kubectl apply -f kc2017/kafka-clients/deploy-plain.yaml
kubectl get pod
kubectl logs $(kubectl get pod -l app=kafka-consumer -o name) -f
kubectl delete -f kc2017/kafka-clients/deploy-plain.yaml

# Deploy kafka
helm install kubernetes-kafka/kafka-cluster --name kafka-cluster
kubectl get pod

# Clients again
kubectl apply -f kc2017/kafka-clients/deploy-plain.yaml
kubectl logs $(kubectl get pod -l app=kafka-producer -o name) -f
# But secured
kubectl apply -f kc2017/kafka-clients/deploy-secured.yaml
kubectl logs $(kubectl get pod -l app=kafka-producer -o name) -f
kubectl delete -f kc2017/kafka-clients/deploy-secured.yaml

# Add topic
kubectl apply -f kc2017/kafka-clients/sample-topic.yaml
kubectl logs $(kubectl get pod -l component=kafka-operator -o name) -f

kubectl logs $(kubectl get pod -l app=kafka-producer -o name) -f
kubectl logs $(kubectl get pod -l app=kafka-consumer -o name) -t 10
kubectl delete -f kc2017/kafka-clients/sample-topic.yaml
kubectl logs $(kubectl get pod -l component=kafka-operator -o name) -f

# Add roles
kubectl apply -f kc2017/kafka-clients/deploy-acl.yaml
kubectl logs $(kubectl get pod -l component=kafka-operator -o name) -f
kubectl get secrets
kubectl logs $(kubectl get pod -l app=kafka-consumer -o name) -t 10


