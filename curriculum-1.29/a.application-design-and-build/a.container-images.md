---
docs : https://kubernetes.io/docs/concepts/containers/images/
---
# Images

`Container Image` 란 application 과 applicatiion 의 모든 의존성을 캡슐화 하는 binary 데이터를 의미합니다. `Container Image` 는 단독으로 실행 할 수 있는 software bundles 입니다.

일반적으로 Image 를 `Pod` 에서 참조하기 전 container image 를 register 에 푸시합니다.

## Image names

Container Image 는 보통 `pause`, `example/mycontainer`, `kube-apiserver` 같은 이름을 가집니다. Image 는 registry 의 Hostname 을 포함 할 수 있습니다; 예를 들어: `fictional.registry.example/imagename`, 그리고 port number 도 가질 수 있습니다; 예를 들어: `fictional.registry.example:10043/imagename`.

registry hostname 을 지정하지 않는다면, Kubernetes 는 `Docker publis registry` 를 Image registry 로 이용한다고 가정합니다. 이는 `Container Runtime` 설정을 통해 변경 될 수 있습니다.

Image name 파트 뒤에는 _tag_, _digest_ 를 추가 할 수 있습니다. 태그와 digest 는 모두 이미지에서 버전을 관리하기 위해 사용됩니다. Tag 는 변경될 수 있지만 Digest 는 고정이라는 점이 다릅니다.

**Examples**
- busybox
- busybox:1.32.0
- registry.k8s.io/pause:latest
- registry.k8s.io/pause:3.5
- registry.k8s.io/pause@sha256:1ff6c18fbef2045af6b9c16bf034cc421a29027b800e4f9b68ae9b1cb3e9ae07
- registry.k8s.io/pause:3.5@sha256:1ff6c18fbef2045af6b9c16bf034cc421a29027b800e4f9b68ae9b1cb3e9ae07

## Updating Images

### Image pull policy

컨테이너의 `ImagePullPolicy` 는 image 의 `tag` 와 함께 `kublet` 이 특정한 이미지를 당기는것을 결정하는데 영향을 줍니다.

- IfNotPresent
  - tag 가 동일한 이미지가 로컬에 있다면 그것을 활용 없다면 당김 
- Always
  - registry 에 대상 image 의 `digest` 를 조회하여 동일한 digest 의 이미지가 로컬에 있다면 그것을 활용
  - 없다면 registry 로 부터 당김
- Never
  - 로컬에 존재할 때만 컨테이너를 시작
  - 없다면 startup 이 실패함

> [!Note]
> Production 에서는 `:latest` 태그를 지양하자.
> 어떤 버전이 활용되었는지 추적하기 어려워지고 rollback 을 수행하기도 어려워진다.

파드가 항상 동일한 버전의 container image 를 사용하는것을 확실히 하기 위하여, image 의 digest 를 명시할 수 있다;
`<image-name>:<tag>` -> `<image-name>@<digest>`. `<image-name>:<tag>` 처럼 활용하는 경우 image registry 가 태그에 대한 이미지를 변경하는 경우 기존 image 와 신규 image 가 섞여서 실행되는 현상이 발생할 수 있다.

thrid-party `admission controllers` 를 통해 pod(pod templates) 가 생성되는 시점에 이를 조작하여 tag 가 아닌 digest 기반으로 이미지가 설정되도록 할 수 있다. Registry 에서 태그에 대한 이미지가 변경되는 경우에도 동일한 이미지를 실행하는것을 보장받고 싶다면 유용 할 것이다.

### Default image pull policy

- ImagePullPolicy 생략, digest 명시              -> IfNotPresent
- ImagePullPolicy 생략, tag `:latest`           -> Always
- ImagePullPolicy 생략, tag 생략                 -> Always
- ImagePullPolicy 생략, `:latest` 가 아닌 tag 명시 -> IfNotPresent

### ImagepullBackOff

- kubelet 이 container runtime 을 이용하는 파드를 위한 container 를 생성할 때, `ImagepullBackOff` 이 발생하여 컨테이너가 대기 상태에 빠질 수 있다.
- e.g.)
  - private registry 에 `imagePullSecret` 을 추가하지 않은 경우
  - image name 이 잘못 된 경우
  
