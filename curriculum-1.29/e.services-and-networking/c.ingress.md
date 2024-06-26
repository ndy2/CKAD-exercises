---
docs: https://kubernetes.io/docs/concepts/services-networking/ingress/
---
# Ingress

Ingress 는 클러스터 내부 서비스로의 외부 접근 (typically HTTP) 을 관리하는 API object 이다.

Ingress 는 또한 load balancing, SSL termination 과 name-based 가상 호스팅을 지원한다.

## Terminology

- Node: Kubernetes 의 worker maching, cluster 의 일부
- Cluster: Kubernetes 에 의해 관리되는 컨테이너화된 애플리케이션을 실행하는 Nodes 의 집합
- Edge router: 클러스터에 방화벽 정책을 강제하는 router. Cloud provider 가 관리하는 gateway 혹은 물리적인 하드웨어 일 수 있다.
- Cluster network: Kubernetes networking model 에 대응하는, cluster 내부의 물리적, 논리적 link 집합
- Service: Label selectors 를 이용해 Pods 를 식별하는 Kubernetes Service

## What is Ingress?

Ingress 는 클러스터 외부에서 클러스터 내부의 서비스로의  HTTP, HTTPS routes 를 제공합니다. Traffic routing 은 ingress 자원에 정의 된 규칙에 따라 제어됩니다.

아래는 전달 받은 모든 요청을 Service 로 전달하는 Ingress 예시 입니다.


```mermaid
graph LR;
    client([client])-. Ingress-managed <br> load balancer .->ingress[Ingress];
    ingress-->|routing rule|service[Service];
    subgraph cluster
    ingress;
    service-->pod1[Pod];
    service-->pod2[Pod];
    end
    classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
    classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
    classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
    class ingress,service,pod1,pod2 k8s;
    class client plain;
    class cluster cluster;
```

Ingress 는 Services 에게 외부에서 접근 가능한 URLs 를 주기 위해, traffic 을 load balance 하기 위해, SSL/TLS 연결을 종료하기 위해, name-based virtual hosting 을 하기 위해 사용될 수 있습니다. 

Ingress 는 임의의 포트/프로토콜을 expose 하지 않습니다. 외부에 HTTP/HTTPS 이상의 서비스를 노출할 때는 보통 `Service.Type=NodePort` 혹은 `Service.Type=LoadBalancer` 를 이용합니다.

## Prerequisites

Ingress 를 만족하는 `Ingress Controller` 가 꼭 있어야 합니다. Ingress 만 생성하는 것은 아무런 효과가 없습니다.

`ingress-nginx` 와 같은 Ingress controller 를 배포해야 할 수 있습니다. [`Ingress controllers`](0.ingress-controller.md) 를 참고하세요.

이상적으로는, 모든 Ingress controller 가 ss