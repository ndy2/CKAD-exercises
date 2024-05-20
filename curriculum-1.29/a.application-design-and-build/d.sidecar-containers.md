---
docs: https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/
---

# Sidecar Containers

Sidecar Containers 란 메인 애플리케이션과 동일한 파드에서 실행되는 보조 컨테이너이다. 이는 보통 메인 _app container_ 의 기능을 향상 시키거나 확장하기 위해 사용된다. 일반적인 확용 방법은 추가적인 서비스 혹은 로깅, 모니터링, 보안과 같은 부가적인 기능을 제공하는 것이다.

일반적으로, 파드당 하나의 app 컨테이너를 가진다. 만약, 로컬 웹 서버가 필요한 웹 애플리케이션을 실행하고자 한다면, 로컬 웹 서버는 sidecar 이고 웹 애플리케이션이 app 컨테이너 이다.

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