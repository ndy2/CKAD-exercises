---
docs: https://kubernetes.io/docs/concepts/security/service-accounts/
---
# Service Accounts

ServiceAccount 에 대해서 소개합니다. service accounts 의 동작, 활용 사례, 한계점, 대안 등을 다룹니다.

## What are service accounts?

`service account` 란 non-human account 의 일종으로, kubernetes 에서는 Kubernetes cluster 내부에서의 ID 처럼 활용 됩니다. Application Pods, system components, 그리고 cluster 내부/외부의 다양한 엔티티 들은 ServiceAccount 의 credential 을 통해 identify 할 수 있습니다. 이러한 indentity 는 API 서버에 인증하는것 혹은 identity 기반 보안 정책을 구현 하는등의 다양한 상황에서 활용 될 수 있습니다.

Service accounts 는 API server 의 ServiceAccount 객체로서 존재합니다. Service accounts 는 아래와 같은 특성을 가집니다.

- Namespaced: 각 service account 는 Kubernetes `namespace` 에 한정됩니다. 모든 namespace 는 생성 될 때 `default` ServiceAccount 를 가집니다.
- Lightweight: Service account 는 cluster 내부에 Kubernetes API 로 정의 됩니다. 특정 작업을 위해 빠르게 service account 를 생성해 활용 할 수 있습니다.
- Portable: 복잡한 containerize workload 를 위한 설정 번들은 시스템 요소를 위한 service account 정의를 포함 하고 있을 수 있습니다. Namespace/Lightweight 한 service account 의 특성은 이런 설정이 Portable 하게 합니다.

