---
docs: https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/
---
# Sidecar Containers

> [!NOTE] FEATURE STATE: Kubernetes

TODO - mergeme

## Sidecar containers in Kubernetes

kubernetes 는 sidecar containers 를 `init-containers` 의 특별한 케이스 로서 구현합니다; sidecar container 는 파드의 실행 이후에도 남아서 유지 됩니다.

### Example applications

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: alpine:latest
          command: ['sh', '-c', 'while true; do echo "logging" >> /opt/logs.txt; sleep 1; done']
          volumeMounts:
            - name: data
              mountPath: /opt
      initContainers:
        - name: logshipper
          image: alpine:latest
          restartPolicy: Always
          command: ['sh', '-c', 'tail -F /opt/logs.txt']
          volumeMounts:
            - name: data
              mountPath: /opt
      volumes:
        - name: data
          emptyDir: {}
```

## Application containers 와의 차이점

TODO

## Init containers 와의 차이점

TODO