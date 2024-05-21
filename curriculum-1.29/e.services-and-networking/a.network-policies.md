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

