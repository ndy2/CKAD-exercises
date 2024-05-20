---
docs: https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/
---
# Ephemeral Containers

> [!NOTE] FEATURE STATE: Kubernetes v1.25 [stable]

ephemeral containers: 존재하는 파드의 내부에서 임시로 디버깅/트러블슈팅의 목적 등으로 실행되는 임시 컨테이너.

## Debug Pods using ephemeral containers


```
kubectl debug -it <pod-name> --image=busybox --target=<container-name>
```

