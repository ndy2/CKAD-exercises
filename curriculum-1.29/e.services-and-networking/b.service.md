---
docs: https://kubernetes.io/docs/concepts/services-networking/service/
---
# Service

Kubernetes 에서, Service 는 클러스터 내부에서 하나 이상의 파드의 형태로 실행 중인 네트워크 애플리케이션을 외부로 노출하는 방법입니다.

Kubernetes `Service` 의 핵심 목표는 Service Discovery mechanisim 을 위해 애플리케이션 코드를 수정하지 않도록 하는 것입니다. 코드는 파드 내부라면, cloud-native 를 위해 작성 되었든, 오래된 containerized app 으로 작성 되었든 상관 없이 실행 될 수 있습니다. 당신은 서비스를 이용하여 네트워크에서 여러 파드를 avaialble 하게 할 수 있습니다.

애플리케이션을 실행하기 위해 `Deployment` 를 사용 한다면, `Deployment` 는 Pods 를 동적으로 생성/제거 할 수 있습니다. 하지만 순간순간마다 얼마나 많은 Pod 가 정상적으로 작동하고 있는지 알 수 없으며, 심지어 그 정상적인 Pod 의 이름이 무엇인지도 모를 수 있습니다. Kubernetes Pods 는 Cluster 의 원하는 상태에 맞추기 위해 생성되고 제거 됩니다. Pods 는 임시 자원입니다. (개별 Pod 가 안정적이라고 기대 하면 안됩니다.)

각 Pod 는 자신의 IP 주소를 가집니다. cluster 내의 주어진 Deployment 에서, 한 시점에 실행 중인 Pods 모음은 다른 시점의 Pods 모음과 다를 수 있습니다.

이것은 하나의 문제를 야기합니다: 만약 클러스터 내 파드 집합이 서로 호출관계에 있다면 (e.g. `frontend/backend`), frontend 파드는 어떻게 어떻게 연결할 IP 목록을 찾고 유지 할 수 있을까요?

Enter *`Services`*

## Services in Kubernetes

Kubernetes 에서 Service API 란, 네트워크를 통해 파드 그룹을 노출하는것에 대한 abstraction 입니다. 각 서비스 객체는 논리적인 endpoint 집합과 함께 어떻게 이러한 파드에 접근할 지에 대한 정책을 정의 합니다.

예를 들어, 3 개의 replicas 로 실행 중인 stateless 한 이미지 처리 backend application 을 생각해 봅시다. replica 들은 서로 대체 가능하므로 frontend 는 어떤 backend pod 를 사용하든지 신경 쓰지 않습니다. 한편 실제 backend set 을 구성하는 파드가 변할 수도 있죠. 따라서 backends 집합 자체를 추적 해서는 안됩니다.

Service 의 추상화는 이런 decoupling 을 가능하게 합니다.

Service 에 의해 지정된 파드 집합은 보통 정의한 `selector` 에 의해 결정 됩니다. (Service endpoint 을 정의하는 다른 방법도 있습니다.)

만약 HTTP 를 다룬다면, web traffic 이 애플리케이션 까지 도달하는 과정을 제어하기 위해 [`Ingress`](c.Ingress.md) 를 이용 할 수도 있습니다, 반면 Ingress 는 cluster 의 entry point 처럼 동작합니다. Ingress를 통해 여러 서비스의 라우팅 규칙을 하나의 리소스로 통합할 수 있으며, 외부에서는 단일 리스너(하나의 IP 주소나 도메인)를 통해 클러스터 내의 여러 서비스에 접근할 수 있습니다.

Kubernetes 의 Gateway API 는 Ingress 와 Service 이상의 기능을 제공합니다.

### Cloud-native service discovery

애플리케이션 내에서 Service Discovery 를 위해 Kubernetes APIs 를 사용 할 수 있다면, API server 에 직접 질의 하여 매칭되는 EndpointSlices 를 조회 할 수 있습니다. Kubernetes 는 Service 내의 Pods 가 변경 될 때 마다 EndpointSlices 를 업데이트 합니다.

cloud native 하지 않은 애플리케이션 에는, kubernetes 는 application 과 뒷단 파드 사이에 network port 혹은 load balancer 를 위치할 방법을 제공합니다.

어느 방식으로든, 애플리케이션은 연결하고자 하는 타겟을 찾기위해 [Service Discovery] 메커니즘을 활용합니다.

## Definding a Service

TODO
