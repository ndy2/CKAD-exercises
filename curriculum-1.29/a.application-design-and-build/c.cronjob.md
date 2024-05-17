---
docs: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
---

# CronJob

_CronJob_ 은 Job 을 반복적인 schedule 로 실행 합니다.

CronJob 은 backups, report 생성과 같은 정기적인 작업을 수행하는 것을 의미합니다. CronJob 은 `Cron` 포맷으로 작성된 스케쥴에 따라 주기적으로 Job 을 실행합니다.

## CronJob spec 작성

### Schedule syntax

`.spec.schedule` 필드는 `Cron` 문법으로 작성되어야 하는 필수 필드입니다.

```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday)
# │ │ │ │ │                                   OR sun, mon, tue, wed, thu, fri, sat
# │ │ │ │ │ 
# │ │ │ │ │
# * * * * *
```
e.g.) `0 0 13 * 5` : 13일의 금요일 정각

혹은 아래 macro 도 사용할 수 있습니다.
- `@yaerly` (or `@annually`) - 0 0 1 1 *
- `@monthly` - 0 0 1 * *
- `@weekly` - 0 0 * * 0
- `@daily` - 0 0 * * *
- `@houlry` - 0 * * * * *

### Job template

`.spec.jobTemplate` 필드는 Job 의 spec 과 동일하며 CronJob 이 생성할 Job 을 정의합니다.

### Deadline for delayed Job start

`.spec.startingDeadlineSeconds` 필드는 옵셔널한 필드입니다. 이 필드는 Job 이 스케쥴되지 않으면 스킵 될 Deadline 을 설정합니다.

## CronJob limitations

### TimeZone 지원 X
TODO

### CronJob 수정
TODO

### Job 생성 두번?
TODO
