#!/bin/sh

NAMESPACE=$1
HOSTNAME=$2


cat <<END
apiVersion: apps/v1
kind: Deployment
metadata:
  name: registry
  namespace: ${NAMESPACE}
  labels:
    app: registry
spec:
  replicas: 1
  selector:
    matchLabels:
      app: registry
  template:
    metadata:
      labels:
        app: registry
    spec:
      containers:
      - name: registry
        image: registry:2.7.1
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: registry
  namespace: ${NAMESPACE}
spec:
  type: LoadBalancer
  selector:
    app: registry
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 5000
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: registry
  namespace: ${NAMESPACE}
spec:
  rules:
  - host: ${HOSTNAME}
    http:
      paths:
      - path: /
        backend:
          serviceName: registry
          servicePort: 5000
END