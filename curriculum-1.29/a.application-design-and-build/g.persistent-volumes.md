---
docs: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
---
# Persistent Volumes

## Introduction

`저장소 - storage` 를 관리하는 것은 컴피팅 인스턴스를 관리 하는것은 별개의 문제입니다. `PersistentVolume` 시스템은 사용자와 관리자에게 저장소가 어떻게 제공되는지에 대한 세부 내용을 저장소가 어떻게 사용되는지와 분리합니다. 이를 위해 kubernetes 는 두가지 resources 를 소개합니다.; PersistentVolume and PersistentVolumeClaim.

`PersistentVolume` 은 관리자에 의해 provisioned 된 혹은 `Storage Classes` 를 통해 동적으로 provisioned 된 저장소입니다. Node 가 Cluster 의 `자원` 이듯이 PV 는 Node 의 자원입니다. PV 는 파드와 독립된 라이프 사이클을 가지는 volume plugin 입니다. 이 API Object 는 NFS, iSCSI, 혹은 클라우드 저장소 시스템과 같은 저장소의 구체적인 동작을 관리합니다.

`PersistentVolumeClaim` 은 user 에 의한 저장소 요청 입니다. PVC 는 파드와 유사합니다. 파드가 노드 자원을 사용하듯이 PVC 는 PV 자원을 활용합니다. 파드는 노드에게 CPU/Memory 를 요청합니다. Claim 은 Volume 의 크기와 access modes 를 요청할 수 있습니다.

PVC 는 사용자가 추상화된 저장소 자원을 사용할 수 있도록 합니다. 관리자는 사용자에게 저장소의 세부적인 구현을 노출하지 않으면서도 다양한 크기와 access mode 를 가진 PV 를 제공할 수 있어야 합니다. 이를 위해서는 `StorageClass` 자원을 이용합니다.

## Lifecyle of a volume and claim

PVs 는 클러스터의 자원입니다. PVC 는 그 자원에 대한 claim 요청 입니다. PV/PVC 의 인터렉션은 아래 라이프 사이클을 따릅니다.

### Provisioning

#### Static Provisioning

클러스터 관리자는 미리 PV 를 생성 합니다. PV 는 실제 저장소의 세부적인 사항을 포함합니다.

#### Dynamic Provisioning

사용자에 PVC 에 매칭되는 정적인 PV 가 존재하지 않는 다면, 클러스터는 PVC 를 위한 volume 을 동적으로 생성할 수도 있습니다. 이러한 Provisioning 은 `StorageClass` 에 의해 이루어 집니다; PVC 는 `storage class` 를 요청하고 관리자는 해당 storage class 를 만들어 놓아야 합니다. storage class 를 `""` 로 설정하여 명시적으로 dynamic provisioning 을 disable 할 수 있습니다.

### Binding

PVC 가 생성되면 `control plane` 의 control loop 는 매칭되는 PV 를 찾아 bind 합니다. 만약 PV 가 PVC 에 의해 dynamic provisioned 되었다면 둘은 항상 bind 됩니다. 그렇지 않다면 User 는 항상 요청한 것을 최소로 만족하는 PV 를 받습니다. 한번 Bound 되면 bind 든 독립적입니다. PV-PVC bind 는 ClaimRef 를 이용하여 one-to-one bi-directional 으로 매핑됩니다.

Cliam 은 매칭되는 volume 이 없다면 계속 unbound 한 상태를 유지합니다. 매칭되는 volume 이 생성되면 bound 됩니다.

### Using

파드는 claim 을 volume 처럼 활용합니다.

Pod 의 `volume` 블락에 `persistentVolumeClaim` 을 활용하여 claim 을 이용할 수 있습니다.

### Storage Object in Use Protection

저장소 객체의 `in Use Protection` 기능을 통해 사용중인 PVC 와 PV 의 삭제를 막을 수 있습니다. PVC 와 PV 의 임의 삭제는 데이터 손실로 이어 질 수 있기 때문에 위험합니다.

사용자가 Pod 가 사용중인 PVC 를 제거하려 하면, PVC 는 바로 제거 되지 않고 PVC 가 어느 Pod 에도 사용되지 않을 때 까지 제거가 지연됩니다. 마찬가지로 PVC 가 이용중인 PV 를 제거 하려 한다면 PV 의 제거도 지연됩니다.

`kubectl describe pv/pvc my-pv/pvc` 결과 (사용 중일때 강제 제거 한 경우)

```shell
Finalizers:      [kubernetes.io/pv-protection]
Status:          Terminating
```

## Persistent Volumes & PersistentVolumeClaims

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
  mountOptions:
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```

 **Capacity** - 용량
 **Volume Mode** - Filesystem(default)/Block
 **Access Mode** - 접근 모드 - ReadWriteOnce/ReadOnlyMany/ReadWriteMany/ReadWriteOncePod

**Class**
- `storageClassName` 으로 결정되는 Class 를 가질 수 있다.
- 설정하지 않으면 PVC 에도 class 를 설정하지 않은 경우에만 bound 될 수 있다.

