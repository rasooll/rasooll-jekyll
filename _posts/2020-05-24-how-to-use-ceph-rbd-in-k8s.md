---
layout: post
title: آموزش استفاده از Ceph RBD در کوبرنتیز
category: آموزشی
postimg: /images/post/k8s-ceph.png
tags: [kubernetes,k8s,ceph,rbd,remotestorage,storageclass]
---
<p align="center"><img src="/images/post/k8s-ceph.png" alt="Kubernetes + Ceph LOGO" /></p>
امروز می‌خوام توی این پست درباره‌ی نحوه استفاده از Ceph RDB در PVC های کوبرنتیز بنویسم. <br>
توجه: در این آموزش فرض بر این است که شما از یک Ceph provider سرویس می‌گیرید، لذا از توضیحات مربوط به ساخت Pool در Ceph صرف نظر شده است.

خب تا اینجای کار شما باید اطلاعات اتصال به یک Ceph pool را داشته باشید که در ادامه از آنها استفاده خواهیم کرد.

### قدم اول - راه اندازی rbd-provisioner :

برای دیپلوی کردن rbd-provisioner می‌توانید از این [پروژه](https://github.com/rasooll/rbd-provisioner) در گیت‌هاب با استفاده از دستورات زیر استفاده کنید:

```sh
$ git clone https://github.com/rasooll/rbd-provisioner.git
$ kubectl apply -n kube-system -f ./rbd-provisioner/deply
```

به این صورت می‌توانیم دیپلوی را چک کنیم:

```
$ kubectl get pods -l app=rbd-provisioner -n kube-system
NAME                               READY   STATUS    RESTARTS   AGE
rbd-provisioner-75b85f85bd-p9b8c   1/1     Running   0         3m45s
```

در اینجا ما توانستیم rbd-provisioner را در نیم‌اسپیس `kube-system` دیپلوی کنیم.

### قدم دوم - ساخت Secretها:

برای `admin-key` و `client-key` که از سرویس دهنده Ceph گرفته‌ایم نیاز است یک سکرت به صورت زیر بسازیم:

```sh
$ kubectl create secret generic ceph-admin-secret \
    --type="kubernetes.io/rbd" \
    --from-literal=key='<key-value>' \
    --namespace=kube-system
```

به جای `<key-value>` باید مقدار `admin-key` خود را قرار دهید.
و برای `client-key` هم به همین صورت:

```sh
kubectl create secret generic ceph-k8s-secret \
  --type="kubernetes.io/rbd" \
  --from-literal=key='<key-value>' \
  --namespace=kube-system
```

### قدم سوم - ساخت Storage Class:

فرض می‌کنیم آدرس مانیتورهای Ceph ما به صورت زیر باشد:

- 10.10.10.11:6789
- 10.10.10.12:6789
- 10.10.10.13:6789

لازم هست برای آنها Service و ‌Endpoint بسازیم چون اگر زمانی آدرس آنها تغییر کند و ما مستقیما از آنها در storageClass خود استفاده کرده باشیم تمامی PVC هایی که قبلا ساخته ایم دیگر کار نخواهند کرد.

در ابتدا این پروژه را Clone می‌کنیم:

```sh
$ git clone https://github.com/rasooll/k8s-ceph-storageclass.git
```

سپس فایل های endpoint و storageClass را با اطلاعاتی که از سرویس دهنده Ceph گرفته‌ایم تکمیل می‌کنیم و با استفاده از دستور زیر storageClass را می‌سازیم:

```sh
$ kubectl apply -n kube-system -f ./k8s-ceph-storageclass/deploy
```

### قدم چهارم - ساخت PVC برای تست:

ابتدا فایل مربوط به ساخت pvc را ایجاد می‌کنیم:

```sh
$ vim ceph-rbd-claim.yml
```
```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: ceph-rbd-claim1
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ceph-rbd
  resources:
    requests:
      storage: 1Gi
```

سپس آن را اعمال می‌کنیم:

```sh
$ kubectl apply -f ceph-rbd-claim.yml
persistentvolumeclaim/ceph-rbd-claim1 created
```

و در نهایت خواهیم داشت:

```sh
$ kubectl get pvc
NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
ceph-rbd-claim1   Bound    pvc-c6f4399d-43cf-4fc1-ba14-cc22f5c85304   1Gi        RWO            ceph-rbd       43s
```
اگر مانند خروجی بالا بود که همه چیز ردیف هست اما اگر نبود به من پیام بدید!