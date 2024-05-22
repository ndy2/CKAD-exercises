---
docs: https://kubernetes.io/docs/concepts/configuration/secret/
---
# Secrets

Secret 은 password, token 혹은 key 와 같은 적은 양의 민감한 정보를 가지는 object 입니다. 이러한 정보는 Pod 의 명세나 container image 에 포함될 수 있습니다. Secret 을 이용하면 비밀 데이터를 애플리케이션에 포함하지 않아도 됩니다.

Secrets 는 이를 사용하는 Pods 와 독립적으로 생성 될 수 있기 때문에, Pods 를 생성, 조회, 수정 하는 과정에서 Secret 이 노출될 위험이 적습니다. Kubernetes, 그리고 클러스터에서 실행되는 애플리케이션에서는 민감 데이터를 비 휘발성 저장소에 작성하지 않는 등의 추가적인 예방을 수행 할 수 있습니다.

Secret 은 ConfigMaps 와 유사하지만 confidential 데이터를 저장하는 것에 특화 되어 있습니다.

## Uses for Secrets

Secret 을아래와 같은 목적으로 사용할 수 있습니다.

- Container 의 환경변수 설정
- SSH keys 혹은 password 같은 credential 을 파드에 저장
- kubelet 이 private registries 로 부터 이미지를 당기도록 함

Kubernetes control plane 역시 Secret 을 이용합니다; 예를 들어, `bootstrap token Secrets` 는 자동화된 노드 등록을 위한 메커니즘 입니다.

### Use case: dotfiles in a secret volume

dot 으로 시작하는 key 를 통해 `hidden` data 를 만들 수 있습니다. 이 키는 dotfile 혹은 `숨김` 파일을 의미합니다. 예를 들어, 아래 Secret 이 volume: `secret-volume` 에 마운트 될 때, 이 볼륨은 `.secret-file` 이라는 하나의 파일을 포함합니다, 또한 `dotfile-test-container` 는 이 파일을 `/etc/secret-volume/.secret--file` 에 가집니다.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dotfile-secret
data:
  .secret-file: dmFsdWUtMg0KDQo=
---
apiVersion: v1
kind: Pod
metadata:
  name: secret-dotfiles-pod
spec:
  volumes:
    - name: secret-volume
      secret:
        secretName: dotfile-secret
  containers:
    - name: dotfile-test-container
      image: registry.k8s.io/busybox
      command:
        - ls
        - "-l"
        - "/etc/secret-volume"
      volumeMounts:
        - name: secret-volume
          readOnly: true
          mountPath: "/etc/secret-volume"
```

### Use case: Secret visible to one container in a Pod

메시지에 HMAC 해싱을 적용하는 복잡합 HTTP 프로그램을 생각해봅시다. 복잡한 애플리케이션 로직 사이로, 서버의 private key 를 탈취하고자 하는 공격자가 있을 수 있습니다.

이를 두 containers 의 두 process 로 나눌 수 있습니다. 앞단의 컨테이너는 user interaction 와 business logic 을 처리합니다, 하지만 private key 는 접근 할 수 없습니다; 그리고 private key 에 접근 할 수 있는 signer container 가 있습니다, 이는 오직 signing 요청을 처리합니다.

이를 통해 공격자는 private key 탈취를 위해 더욱 복잡한 공격을 수행해야 합니다.


## Secret 의 종류

|Built-in Type|Usage|
|---|---|
|`Opaque`|arbitrary user-defined data|
|`kubernetes.io/service-account-token`|ServiceAccount token|
|`kubernetes.io/dockercfg`|serialized `~/.dockercfg` file|
|`kubernetes.io/dockerconfigjson`|serialized `~/.docker/config.json` file|
|`kubernetes.io/basic-auth`|credentials for basic authentication|
|`kubernetes.io/ssh-auth`|credentials for SSH authentication|
|`kubernetes.io/tls`|data for a TLS client or server|
|`bootstrap.kubernetes.io/token`|bootstrap token data|

### Opague Secrets

### ServiceAccount token Secrets

### SSH authentication Secrets

### TLS Secrets

## Working with Secrets

