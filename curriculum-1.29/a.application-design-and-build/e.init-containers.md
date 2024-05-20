---
docs: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
---
# Init Containers

Init containers: 파드의 앱 컨테이너를 실행하기 전 실행되는 특별한 컨테이너입니다. 초기화 컨테이너는 애플리케이션 이미지에 존재하지 않는 초기화 스크립트를 실행할 수 있습니다.

`sidecar container` 는 앱 컨테이너 이전에 실행되어 계속해서 실행합니다. 하지만 Init containers 는 초기화 시에 실행되고 종료됩니다.

## Understanding init containers

Init conainers 는 일반적인 컨테이너와 동일하지만 아래 두가지만 다릅니다.

- 초기화 컨테이너는 종료되기 위해 실행됩니다.
- 초기화 컨테이너는 순차적으로 실행됩니다.
- 초기화 컨테이너는 lifecycle, livenessProbe, readinessProbe, or startupProbe 필드를 이용할 수 없습니다. (sidecar container 는 이용 할 수 있음)

