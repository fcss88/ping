## Все работы проводим с первого мастера.

### DaemonSet

Переходим в директорию с практикой.
```bash
cd advanced-abstractions
```

Создаем даемонсет
```bash
kubectl apply -f daemonset.yaml
```
В ответ должны увидеть
```bash
daemonset.extensions/node-exporter created
```
Смотрим на поды
```bash
kubectl get pod -o wide
```
Видим
```bash
NAME                  READY   STATUS    RESTARTS   AGE   IP            NODE                               
node-exporter-g5tt8   2/2     Running   0          11s   10.107.32.4   gke-s000-default-pool-41fb7951-ntk8
node-exporter-xpb9f   2/2     Running   0          22s   10.107.32.2   gke-s000-default-pool-41fb7951-lkjn
```
Чистим за собой кластер
```bash
kubectl delete -f daemonset.yaml
```

### StatefulSet

Создаем стэйтфулсет
```bash
kubectl apply -f rabbitmq-statefulset
```
В ответ должны увидеть
```bash
configmap/rabbitmq-config created
role.rbac.authorization.k8s.io/endpoint-reader created
rolebinding.rbac.authorization.k8s.io/endpoint-reader created
service/rabbitmq created
serviceaccount/rabbitmq created
statefulset.apps/rabbitmq created
```
Смотрим на поды
```bash
kubectl get pod
```
Видим
```bash
NAME         READY   STATUS              RESTARTS   AGE
rabbitmq-0   0/1     ContainerCreating   0          31s
```
Поды начали создаваться по одному, с нулевого
Ждем, пока get pod не вернет все три работающих пода
Должно быть так
```bash
NAME         READY   STATUS    RESTARTS   AGE
rabbitmq-0   1/1     Running   0          10m
rabbitmq-1   1/1     Running   0          7m
rabbitmq-2   1/1     Running   0          5m
```
Проверяем что под каждый pod создался pvc
```bash
 kubectl get pvc
```
Видим
```bash
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-rabbitmq-0   Bound    pvc-d9030631-496e-11e9-96e5-4201ac101193   2Gi        RWO            standard       10m
data-rabbitmq-1   Bound    pvc-01c40ac5-496f-11e9-96e5-4201ac101193   2Gi        RWO            standard       7m
data-rabbitmq-2   Bound    pvc-3332550d-496f-11e9-96e5-4201ac101193   2Gi        RWO            standard       5m
```
Проверяем сервис
Запускаем под для тестов
```bash
kubectl run -t -i --rm --image amouat/network-utils test bash
```
Дальше уже из этого пода выполняем
```bash
nslookup rabbitmq
```
В ответ видим, что DNS возвращает IP всех подов (IP подов можно проверить в соседней консоли через kubectl get pod -o wide)
```bash
Server:		10.107.0.10
Address:	10.107.0.10#53

Name:	rabbitmq.default.svc.cluster.local
Address: 10.107.16.12
Name:	rabbitmq.default.svc.cluster.local
Address: 10.107.16.13
Name:	rabbitmq.default.svc.cluster.local
Address: 10.107.18.24
```
Пробуем резолвить конкретный инстанс
```bash
nslookup rabbitmq-0.rabbitmq
```
В ответ видим, что DNS возвращает IP пода rabbitmq-0
```bash
Server:		10.107.0.10
Address:	10.107.0.10#53

Name:	rabbitmq-0.rabbitmq.default.svc.cluster.local
Address: 10.107.16.12
```
Выходим из тестового пода
```bash
exit
```
Чистим за собой кластер
```bash
kubectl delete -f rabbitmq-statefulset
kubectl delete pvc --all
```
Обязательно удаляем PVC отдельно! Удаление стэйтфулсета не чистит PVC

### Job

Создаем job
```bash
kubectl apply -f job.yaml
```
Проверяем
```bash
kubectl get job
```
Видим
```bash
NAME    COMPLETIONS   DURATION   AGE
hello   1/1           2s         88s
```
Смотрим на поды
```bash
kubectl get pod
```
Видим под, созданный джобой
```bash
NAME          READY   STATUS      RESTARTS   AGE
hello-6l9tv   0/1     Completed   0          2m6s
```
Смотрим его логи
```bash
kubectl logs hello-6l9tv
```
Видим что все отработало правильно
```bash
Mon Mar 18 15:06:10 UTC 2019
Hello from the Kubernetes cluster
```
Удаляем джоб
```bash
kubectl delete job hello
```
Проверяем работу параметра backoffLimit
Открываем файл job.yaml
Находим командy выполняющуюся в поде
```yaml
args:
  - /bin/sh
  - -c
  - date; echo Hello from the Kubernetes cluster
```
И ломаем полностью
```yaml
args:
  - /bin/sh
  - -c
  - date; echo Hello from the Kubernetes cluster; exit 1
```
Создаем джоб
```bash
kubectl apply -f job.yaml
```
Проверяем
```bash
kubectl get job
```
Видим
```bash
NAME    COMPLETIONS   DURATION   AGE
hello   0/1           27s        27s
```
Смотрим на поды
```bash
kubectl get pod
```
Видим поды, созданный джобой
```bash
NAME          READY   STATUS   RESTARTS   AGE
hello-5nvqf   0/1     Error    0          22m
hello-ks4ks   0/1     Error    0          22m
hello-rl984   0/1     Error    0          22m
```
Они в статусе Error
Смотрим в описание джобы
```bash
kubectl describe job hello
```
Видим что backoffLimit сработал
```bash
  Warning  BackoffLimitExceeded  23m   job-controller  Job has reached the specified backoff limit
```
Удаляем джоб
```bash
kubectl delete job hello
```
Проверяем работу параметра activeDeadlineSeconds
Открываем файл job.yaml
Находим командy выполняющуюся в поде
```yaml
args:
  - /bin/sh
  - -c
  - date; echo Hello from the Kubernetes cluster
```
И делаем ее бесконечной
```yaml
args:
  - /bin/sh
  - -c
  - while true; do date; echo Hello from the Kubernetes cluster; sleep 1; done
```
Создаем джоб
```bash
kubectl apply -f job.yaml
```
Проверяем
```bash
kubectl get job
```
Видим
```bash
NAME    COMPLETIONS   DURATION   AGE
hello   0/1           27s        27s
```
Смотрим на поды
```bash
kubectl get pod
```
Видим поды, созданный джобой
```bash
NAME          READY   STATUS   RESTARTS   AGE
hello-bt6g6   1/1     Running   0          5s
```
Ждем 100 секунд и проверяем джоб
```bash
kubectl describe job hello
```
Видим что activeDeadlineSeconds сработал
```bash
  Warning  DeadlineExceeded  2m17s  job-controller  Job was active longer than specified deadline
```
Удаляем джоб
```bash
kubectl delete job hello
```

### CronJob

Создаем крон джоб
```bash
kubectl apply -f cronjob.yaml
```
Проверяем
```bash
kubectl get cronjob
```
Видим
```bash
NAME    SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
hello   */1 * * * *   False     0        <none>          14s
```
Через минуту пробуем посмотреть на джобы
```bash
kubectl get job
```
Видим созданный джоб
```bash
NAME               COMPLETIONS   DURATION   AGE
hello-1552924260   1/1           2s         49s
```
Ну и смотрим на поды
```bash
kubectl get pod
```
Видим под
```bash
NAME                     READY   STATUS      RESTARTS   AGE
hello-1552924260-gp7pk   0/1     Completed   0          80s
```
Если мы подождем 5-10 минут, то увидим что старые джобы и поды удаляются по мере пояления новых
Проверить
```bash
kubectl get job,pod
```
Удаляем крон джоб
```bash
kubectl delete -f cronjob.yaml
```

### RBAC

Переходим в директорию RBAC
```bash
cd rbac
```
Создаем объекты
```bash
kubectl apply -f .
```
Видим
```bash
rolebinding.rbac.authorization.k8s.io/user created
serviceaccount/user created
```
Пробуем получить список сервисов по юзером
```bash
kubectl get service --as=system:serviceaccount:default:user
```
Список сервисов возвращается
```bash
NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                 AGE
kubernetes          ClusterIP   10.107.0.1      <none>        443/TCP                                 25h
```
Теперь пробуем удалить сервис kubernetes под юзером
```bash
kubectl delete service --as=system:serviceaccount:default:user kubernetes
```
Видим что RBAC работает
```bash
Error from server (Forbidden): services "kubernetes" is forbidden: User "system:serviceaccount:default:user" cannot delete resource "services" in API group "" in the namespace "default"
```
Чистим за собой кластер
```bash
kubectl delete -f .
```
