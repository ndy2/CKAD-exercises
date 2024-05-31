---
docs: https://kubernetes.io/docs/concepts/configuration/configmap/
---
# ConfigMaps

ConfigMap 은 no-confidential 한 데이터를 key-value 쌍으로 저장하는 API object 입니다. Pods 는 ConfigMaps 를 envrionment variables, command-line arguments, 혹은 volume 의 설정 파일로써 사용 할 수 있습니다.

ConfigMap 은 environment-specific 한 설정 정보를 container images 와 분리 할 수 있도록 하여, 애플리케이션이 쉽게 여러 환경을 가질 수 있도록 합니다.

## ConfigMap object

다른 대부분의 Kubernetes 가 `spec` 필드를 가지는 것 대신, ConfigMap 은 `data` 와 `binaryData` 필드를 가집니다. 두 필드는 오두 optional 필드 입니다. `data` 필드는 UTF-8 문자열을, `binaryData` 는 base64 encoded string 을 포함하도록 디자인 되었습니다.

ConfigMap 의 정의에 `immutable` 필드를 포함하여 데이터가 변경될 수 없도록 할 수 있습니다.

## ConfigMaps and Pods

Pod 의 `spec` 에서 ConfigMap 을 참조하여 Pods 의 containers 에서 ConfigMap 의 데이터를 얻을 수 있습니다. Pod 와 ConfigMap 은 동일한 `namespace` 에 있어야 합니다.

아래는 한줄에 하나의 값을 가지는 key-value 와 file 로써 key 를 포함하는 것 처럼 보이는 key-value 를 포함한 configmap 을 정의하는 yaml 입니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
    name: game-demo
data:
    # property-like keys; each key maps to a simple value
    player_initial_lives: "3"
    ui_properties_file_name: "user-interface.properties"

    # file-like keys
    game.properties: |
        enemy.types=aliens,monsters
        player.maximum-lives=5
    user-interface.properties: |
        color.good=purple
        color.bad=yellow
        allow.textmode=true
```

Pod 의 Container 내부에서 ConfigMap 을 사용하는 네가지 방법이 있습니다.

1. container command 와 args 내부
2. container 의 환경 변수 설정
3. volume 에 추가하여 container 가 읽을 수 있는 파일 생성
4. Pod 내부에서 Kubernetes API 를 이용해 ConfigMap 의 데이터를 읽어드리는 코드 작성

처음 세가지 방법에서는 `kublet` 이 파드의 컨테이너를 시작하는 시접에 ConfigMap 으로부터 데이터를 읽습니다.

네 번째 방법에서 ConfigMap 과 그 데이터를 읽기 위해서 그 코드를 작성해야 합니다. 하지만, Kubernetes 의 API 를 직접 활용 하기 때문에 애플리케이션은 ConfigMap 의 변화를 구독하고 즉시 업데이트 될 수 있습니다. 이 방식에서는 다른 namespace 의 ConfigMap 을 사용 할 수도 있습니다.

