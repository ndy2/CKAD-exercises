---
docs: https://kubernetes.io/docs/concepts/services-networking/network-policies/
---
# Network Policies

TCP,UDP, and SCTP 프로톨에 대하여 IP 주소 혹은 port level 에서 traffic flow 를 제어하고 싶다면, cluster 의 특정 application 에 대한 Kubernetes `NetworkPolicies` 를 사용하는 것을 고려해 보세요. NetworkPolicies는 애플리케이션 중심의 구성 요소로, Pod가 다양한 네트워크 "엔티티"와 어떻게 통신할 수 있는지를 지정할 수 있게 합니다. NetworkPolicies 는 pod 의 한쪽 혹은 양쪽 연결에 적용 될 수 있습니다.

파드가 통신하는 엔티티는 아래 세가지 식별자의 조합으로 결정됩니다.

1. 다른 파드가 허용되는지
2. Namespaces 가 허용 되는지
3. IP blocks

Pod 혹은 namespace 기반의 NetworkPolicy 를 적용할 때는 `selector` 를 통해 이를 결정 할 수 있습니다.

한편, IP 기반의 NetworkPolicy 는 생성 될 때, IP block 에 따른 policy 를 정의 해야 합니다. (CIDR Range - e.g. - 192.168.1.0/24)

## The two sorts of pod isolation

파드의 isolation 에는 두가지가 있습니다.
- isolation for egress
- isolation for ingress

두가지의 isolation 은 독립적으로 선언됩니다, 또한 모두 한 파드에서 다른 파드로의 연결을관리 합니다.

기본적으로, 파드는 egress 에 non-isolated 합니다; 즉, 모든 외부의 연결이 허용됩니다. 만약, 파드를 select 하고 policyTypes 에 "Egress" 를 포함한 `NetworkPolicy` 가 존재한다면 Pod 는 egress 로부터 isolated 됩니다. 이 경우 `pod 에 egress 정책이 적용 되었다` 라고 합니다. 파드가 egress 로 부터 isolated 되었다면, 해당 NetworkPolicy 에 작성된 `egress` 목록에 있는 외부 연결 만이 허용 됩니다. 그 traffic 에 대한 응답으로 발생하는 traffic 은 implicit 하게 허용 됩니다. `egress` 목록에 대한 영향은 모두 중첩적으로 적용됩니다.

기본적으로, pod 는 ingress 에 non-isolated 합니다; 즉, 모든 inbound 연결은 허용 됩니다. 만약, 파드를 select 하고 policyType 에 `Ingress` 를 포함한 `NetworkPolicy` 가 존재한다면 Pod 는 ingress 로 부터 isolated 됩니다. 이 경우 `pod 에 ingress 정책이 적용 되었다` 라고 합니다. 파드가 ingress 로 부터 isolated 되었다면, 해당 NetworkPolicy 에 작성된 `ingress` 목록에 있는 inbound 요청 만이 허용 됩니다. 그 traffic 에 대한 응답으로 발생하는 traffic 은 implicit 하게 허용 됩니다. `ingress` 목록에 대한 영향은 모두 중첩적으로 적용됩니다.

Network policy 는 서로 충돌하지 않습니다; 그들은 합산으로 적용 됩니다. 만일 파드에서 주어진 방향 (inbound or outbound) 으로의 연결을 정의하는 policy 가 여러개 있다면, 그런 연결은 적용할 수 있는 모든 policies 에 대한 union 으로 결정됩니다. 즉, policy 를 평가하는 순서는 결과에 영향을 주지 않습니다.

`source pod -> destionation pod` 로의 연결이 허용 되기 위해서는, source pod 에서의 egress policy 와 destination pod 에서의 ingress pod 가 모두 그 연결을 허용 해야 합니다. 한 쪽이라도 연결을 허용 하지 않으면, 연결 할 수 없습니다.

## The NetworkPolicy resource

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  # Ingress 와 Egress 에 대하여
  # role: db 레이블을 가진 파드를 select 한다.
  podSelector: 
    matchLabels:
      role: db

  # Ingress 와 Egress 를 모두 정의 한다.
  policyTypes:
  - Ingress
  - Egress

  # spec.ingress
  ingress:
  # spec.ingress.from[*].ipBlock
  # 172.17.0.0/16 에서 `172.17.1.0/24` 를 제외한 inbound 요청을 허용
  # 
  # spec.ingress.from[*].namespaceSelector, podSelector
  # selector 를 만족 하는 파드로 부터의 요청을 허용  (Union)
  # 
  # spec.ingress.from[*].ports
  # 이 ingress 정책은 TCP, 6379 port 에서의 inbound 요청을 거부한다.
  
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379

  # spec.egress
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978


```

## Default policies

기본적으로, namespace 에 policies 가 없으면, 모든 ingress/egress traffic 은 허용 됩니다. namespace 에 적용된 기본 정책을 수정하는 예시를 살펴보겠습니다.

### 모든 ingress traffic (inbound) 차단

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### 모든 ingress traffic 허용

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from: {}
```