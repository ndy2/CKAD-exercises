---
https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
---
# Custom Resources

`Custom resources` 는 Kubernetes API 의 확장입니다.

## Custom resources

`resource` 는 Kubernetes API 의 endpoint 입니다. `resources` 는 특정한 종류의 API objects 의 모음을 저장합니다; 예를 들어, `pods` 라고 하는 built-in resource 는 Pod objects 의 모음을 가집니다.

`custom resource` 는 Kubernetes API 의 확장으로 default Kubernetes installation 에서는 이용 할 수 없습니다. 즉, 특정한 kubernetes installation 을 커스텀을 의미합니다. 하지만 최근 많은 core kubernetes 기능들이 custom resources 를 활용합니다. 이는 kubernetes 를 더욱 modular 하게 합니다.

Custom resources 는 실행중인 cluster 에 동적으로 추가/제거 될 수 있습니다. 관리자는 cluster 와 독립적으로 custom resources 를 업데이트 할 수 있습니다. custom resource 가 한번 설치 되면, 사용자는 built-in resource 인 Pods 를 다룰때와 마찬가지로 kubectl 을 통해 custom resources object 를 생성하고 접근 할 수 있습니다.

## Custom controllers

`custom resource` 자체로는 구조화된 데이터를 저장하고 조회 할 수 있습니다. 이를 `custom controller` 와 결합하면 `custom resource` 는 진정한 선언적 API 를 제공합니다.

Kubernetes 의 `declarative API` 는 책임의 분리를 강제합니다. resource 가 원하는 상태를 선언합니다. Kubernetes controller 는 Kubernetes object 의 상태를 원하는 상태와 맞춥니다. 이는 직접 server 의 행동을 지시하는 `imperative API 와는 대조적입니다.

cluster 의 라이프사이클과 독립적으로 실행중인 cluster 의 custom controller 를 배포하고 업데이트 할 수 있습니다. Custom controllers 는 어떤 종류의 resource 에도 동작할 수 있지만 custom resource 와 함께 사용 했을때 특히 효과적입니다. `Operator pattern` 은 custom resources 와 custom controllers 를 결합합니다. custom controller 를 통해 특정 애플리케이션의 도메인 지식을 Kubernetes API 의 확장으로 나타낼 수 있습니다.

## Adding custom resources

Kubernetes 는 cluster 에 custom resources 를 추가 할 수 있는 두가지 방법을 제공 합니다.

- CRDs 는 간단하고 프로그래밍 없이 생성 될 수 있습니다.
- API Aggregation 은 프로그래밍을 해야 하지만, API 버전 변경시 데이터가 어떻게 처리될지 와 같은 더욱 정교한 컨트롤을 제공합니다.
