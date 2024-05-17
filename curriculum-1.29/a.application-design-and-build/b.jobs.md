---
docs: https://kubernetes.io/docs/concepts/workloads/controllers/job/
---

# Jobs

`Job` 은 하나 이상의 Pods 를 생성하며 특정 횟수만큼 성공할 때 까지 Pods 를 실행합니다. Pod 가 성공적으로 종료되면, Job 은 성공 결과를 관리합니다. Job 을 제거하면 해당 Job 이 생성한 Pods 는 모두 제거됩니다. Suspending 하는 Job 은 재시작 되기 전 까지 자신의 Pods 를 제거합니다.

단순한 케이스는 반드시 단 한번 성공해야 하는 파드를 위한 Job 을 생성하는 것입니다. Job 은 Pod 가 실패하는 경우 pod 를 새로 생성합니다.

Job 을 이용해 여러 파드를 병렬적으로 실행 할 수 있습니다.

## Job spec 작성

### Parallel execution for Jobs

1. Non-parallel Jobs
TODO

2. Parallel Jobs with a _fixed completion count_
TODO

3. Parallel Jobs with a _work queue_
TODO

### Completion mode

TODO

## Handling Pod and container failures
TODO

## Success policy
TODO

## Job termination and cleanup
TODO

## Clean up finished jobs automaticeally
TODO

## Alternatives
TODO

1. Bare Pods
2. Replication Controller
3. Single Job starts controller Pod