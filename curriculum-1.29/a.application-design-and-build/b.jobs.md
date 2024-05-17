---
docs: https://kubernetes.io/docs/concepts/workloads/controllers/job/
---
# Jobs

`Job` 은 하나 이상의 Pods 를 생성하며 특정 횟수만큼 성공할 때 까지 Pods 를 실행합니다. Pod 가 성공적으로 종료되면, Job 은 성공 결과를 관리합니다. Job 을 제거하면 해당 Job 이 생성한 Pods 는 모두 제거됩니다. Suspending 하는 Job 은 재시작 되기 전 까지 자신의 Pods 를 제거합니다.

단순한 케이스는 반드시 단 한번 성공해야 하는 파드를 위한 Job 을 생성하는 것입니다. Job 은 Pod 가 실패하는 경우 pod 를 새로 생성합니다.

Job 을 이용해 여러 파드를 병렬적으로 실행 할 수 있습니다.

## Job spec 작성

```yaml
apiVersion: batch/v1
kind: Job
metadata:
    name: pi
spec:
    template:
        spec:
            containers:
            - name: pi
                image: perl:5.34.0
                command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
            restartPolicy: Never
    backoffLimit: 4
```

### Pod Template

`.spec.template` 은 `.spec` 의 유일한 필수 항목입니다. template 에는 Job 의 대상이 될 파드의 스펙을 작성하면 됩니다.
### Parallel execution for Jobs

1. Non-parallel Jobs
- 일반적으로, 파드가 실패하지 않는 한, 하나의 파드가 실행됩니다.
- Job 은 Pod 가 성공적으로 종료되면 `complete` 하다고 취급 됩니다.

2. Parallel Jobs with a _fixed completion count_
- `.spec.completions` 에 반복할 횟수를 지정합니다.
- `.spec.completionMode="Indexed"` 를 사용하면 각 파드는 0 .. `.spec.completions-1` 만금의 인덱스를 가집니다.

3. Parallel Jobs with a _work queue_
- `.spec.parallelism` 에 병렬적으로 실행할 횟수를 지정합니다.

### Completion mode

2. Parallel Jobs with a _fixed completion count_ 
로 수행한 Job 에서 `.spec.completionMode="Indexed` 를 사용하면 각 파드에 index 를 부여할 수 있습니다.
- index 는 annotation/label 에 표시됩니다.
- index 는 pod 이름에 표시됩니다.
- 컨테이너 작업이라면 JOB_COMPLETION_INDEX 환경변수가 설정됩니다.

## Handling Pod and container failures

파드의 컨테이너는 여러 이유로 실패할 수 있습니다. non-zero exit code 로 종료하거나, 메모리 초과를 하여 killed 당할 수 있습니다. 이렇게 파드가 실패한 경우 `.spec.template.spec.restartPolicy = "Onfailure"` 라면, 파드는 node 에 남고 컨테이너가 재시작합니다. 따라서, 프로그램이 Pod 레벨에서 restart 되어야 한다면 `.spec.template.spec.restartPolicy = "Never"` 로 명시하세요.

컨테이너가 아닌 전체 파드가 실패할 수도 있습니다. node 에 의해 추방되거나, 내부의 컨테이너가 실패하였지만 `.spec.template.spec.restartPolicy = "Never"` 인 경우가 그렇습니다. 파드가 실패하면 Job contoller 는 새로운 파드를 재시작합니다.

기본적으로, 각 파드는 `.spec.backoffLimit` 만큼 실패 할 수 있습니다.
+) Indexed Job 인 경우 `.spec.backoffLimitPerIndex` 필드를 통해 인덱스 별 backOffLimit 을 지정할 수 있습니다.

## Success policy

> [!NOTE] FEATURE STATE: Kubernetes v1.30 [alpah]

Indexed Job 을 생성하는 경우, Job 이 `성공` 했다고 결정도리 수 있는 조건을 `.spec.successPolicy` 에 설정할 수 있습니다. 기본적으로 Job 은 성공한 파드의 개수가 `.spec.completions` 에 설정된 값과 같은 경우 `성공` 했다고 여겨집니다.


## Job termination and cleanup

Job 이 완료되면, 새로운 파드가 생성되지 않습니다. Pods 는 제거되지 않습니다.
TODO
## Clean up finished jobs automaticeally
TODO

## Alternatives
TODO

1. Bare Pods
2. Replication Controller
3. Single Job starts controller Pod