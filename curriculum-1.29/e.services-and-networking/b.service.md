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

Service 는 `객체` 입니다. Service definition 을 Kubernetes API 를 이용해 생성, 조회 혹은 수정 할 수 있습니다. `kubectl` 과 같은 tool 을 통해 API call 을 할 수 있습니다.

예를 들어, TCP port 8080 을 listen 하고 있으며 `app.kubernetes.io/name=MyApp` 이라고 labelled 된 Pods 집합이 있다면, 아래의 Service 를 통해 TCP listener 를 정의할 수 있습니다.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

위 manifest 를 적용하여 `ClusterIP` 타입의 `my-service` 서비스를 생성할 수 있습니다. 서비스는 `app.kubernetes.io/name: MyApp` 레이블을 가진 모든 파드를 target 합니다.

Kubernetes 는 이 서비스에게 `cluster IP` 라고 불리는 IP 를 부여합니다. 이는 virtual IP address mechanism 에 사용 됩니다.

### Port Definitions

Pods 의 Port 정의는 이름을 가집니다, 그리고 이는 Service 의 `targetPort` 에서 참조될 수 있습니다. 예를 들어, `targetPort` 를 아래와 같이 연결할 수 있습니다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```

이러한 방식은 동일한 Port 이름을 가지는 여러 Pods 와 Service 에도 유효합니다.

## Service type

**ClusterIp**

Service 를 `cluster-internal` 에 노출합니다. Service 는 오직 Cluster 내부에서만 접근 할 수 있습니다. Service 에 type 을 명시하지 않으면 사용되는 기본 값입니다. 이러한 Service 도 Ingress, Gateway 를 이용해 외부에 노출 할 수 있습니다.

**NodePort**

Service 를 각 노드의 IP 에 정적인 port 로 노출합니다. Node port 를 이용하려면, Kubernetes 는 `type: ClusterIP` 를 사용했을때와 마찬가지로 cluster IP 주소를 준비합니다.

**LoadBalancer**

Service 를 외부 load balancer 에 노출합니다. Kubernetes 는 직접 로드 밸런싱 요소를 제공하지 않으며; 직접 제공해야합니다. 혹은 cloud provider 과의 통합을 할 수도 있습니다.

**ExternalName**

`externalName` 필드에 서비스를 매핑합니다.

## Headless Services

TODO
## Discovering services

### Environment variables

TODO
### DNS

TODO