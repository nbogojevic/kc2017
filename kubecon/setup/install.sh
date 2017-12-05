
oc cluster up --public-hostname=oc-master.127.0.0.1.nip.io --routing-suffix=127.0.0.1.nip.io
oc cluster up --public-hostname=127.0.0.1 --routing-suffix=127.0.0.1

oc login -u system:admin && oc adm policy add-cluster-role-to-user cluster-admin developer

oc login https://localhost:8443 -u developer -p developer

export KUBE_EDITOR="code --wait"
export OC_EDITOR="code --wait"

export DOCKER_HOST=https://localhost:2300
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="d:\\git_clones\\next-step\\acs-localdev\\docker-cert"
export KUBECONFIG="D:\\Userfiles\\nbogojevic\\Documents\\.kube\\config"
export KUBERNETES_AUTH_TRYSERVICEACCOUNT=false
export TILLER_NAMESPACE=tiller

# Build prerequisites
DOCKER_HOST=https://localhost:2300 && pushd kc2017/kafka-clients && mvn -o -B install && popd
DOCKER_HOST=https://localhost:2300 && pushd kafka-operator && mvn -o -B install && popd
DOCKER_HOST=tcp://localhost:2300 && docker build -t nbogojevic/kafka kubernetes-kafka/docker-kafka/
DOCKER_HOST=tcp://localhost:2300 && docker build -t nbogojevic/zookeeper kubernetes-kafka/docker-zookeeper/

oc delete project myproject

# Tiller
oc new-project ${TILLER_NAMESPACE}
helm init --client-only
oc process -f tiller-template.yaml -p TILLER_NAMESPACE=${TILLER_NAMESPACE} | oc apply -f -
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

# For prometheus
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:default:default"

oc project default
helm install --name prometheus stable/prometheus

oc new-project kubecon
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
helm install kubernetes-kafka/kafka-secrets --name kafka-secrets
oc apply -f oc-security.yaml
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:kubecon:kafka-operator"

