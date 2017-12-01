#! /bin/bash

helm install kubernetes-kafka/kafka-secrets --name kafka-secrets 

kubectl apply -f kafka-clients/deploy.yaml

kubectl delete -f kafka-clients/deploy.yaml

helm install kubernetes-kafka/kafka-secrets --name kafka-secrets 

kubectl apply -f kafka-clients/deploy.yaml

kubectl apply -f kafka-clients/deploy-secured.yaml
kubectl apply -f kafka-clients/sample-topic.yaml

helm delete kafka-cluster --purge
helm install kubernetes-kafka/kafka-cluster --name kafka-cluster -f kubecon/secured-kafka.yaml
kubectl apply -f kafka-clients/sample-topic.yaml
kubectl apply -f kafka-clients/deploy-acl.yaml

kubectl delete -f kafka-clients/sample-topic.yaml