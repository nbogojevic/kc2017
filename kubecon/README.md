# Prerequisite
minikube start --memory 4096 --vm-driver hyperv --v=7 --alsologtostderr --hyperv-virtual-switch test
& minikube docker-env | Invoke-Expression
mvn install
helm init

# Start 2 microservices

# Show failing microservices

# Explain stateful set

# Start stateful set
helm install /dev/openshift-kafka/kafka-cluster --name kafka-cluster -v kafka.secured=false

# Show brokers, services, pods

# Show failing microservice for different reason
helm delete kafka-cluster

# Provision topics

# Show working microservice

# Talk about persistence

# Show rogue microservice

# Show