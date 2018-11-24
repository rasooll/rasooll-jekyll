---
layout: post
title: آموزش کانفیگ سیستم مانیتورینگ - Prometheus
category: آموزشی
postimg: /images/post/monitoring_prometheus.jpeg
tags: [monitoring,prometheus,devops,docker,linux,sysadmin,مانیتوریگ,لینوکس,مدیریت]
---
<p align="center"><img src="/images/post/monitoring_prometheus.jpeg" alt="Monitoring Prometheus" /></p>
### اول از هر چیزی Prometheus چیست؟
یک سرویس مانیتورینگ همه فن حریف است که به صورت متن باز منتشر می‌شود [پیوند](https://github.com/prometheus/prometheus) ، همچنین این سرویس توسعه پذیری بسیار بالایی دارد و از افزونه‌های زیادی بهره میبرد.

### پیشنیازها:
- Docker
- Docker Compose

#### کانفیگ Docker compose:

```ruby
version: "3"
services:
        prom:
                image: quay.io/prometheus/prometheus
                volumes:
                        - /path/to/file/prometheus.yml:/etc/prometheus/prometheus.yml
                command: "--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus"
                restart: always
                ports:
                        - 9090:9090
```

#### فایل prometheus.yml:

```ruby
global:
    scrape_interval:     15s # By default, scrape targets every 15 seconds.
    evaluation_interval: 15s # By default, scrape targets every 15 seconds.
    external_labels:
          monitor: 'codelab-monitor'
     scrape_configs:
         - job_name: 'prometheus'
     scrape_interval: 5s
     # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
        - targets: ['localhost:9090']
```
- توجه داشته باشید داخل فایل `docker-compose.yml` باید آدرس مربوط به فایل `prometheus.yml` را ویرایش نمایید.

حال با استفاده از دستور زیر باید کانتینر مربوط به Prometheus را اجرا نمایید:

```bash
$ docker-compose up -d
```

خوب تبریک میگم الان شما روی پورت ۹۰۹۰ سرویس Prometheus را دارید.

حال باید کانفیگ مربوط به سرویسی که میخواهید مانیتور کنید را انجام دهید ، Prometheus پارامترهای مورد نیاز را از طریق Exporter ها دریافت می‌کند [لیست کامل](https://prometheus.io/docs/instrumenting/exporters/)

### راه اندازی و کانفیگ exporter برای Prometheus:

داخل فایل `docker-compose.yml` در بخش `services` تنظیمات زیر را اضافه میکنیم:

```ruby
postgres:
     image: wrouesnel/postgres_exporter
     ports:
            - "9187:9187"
     environment: DATA_SOURCE_NAME="postgresql://postgres:password@localhost:5432/?sslmode=disable"
```

حال لازم است که داخل فایل `prometheus.yml` را نیز ویرایش نمایید و در انتهای آن تنظیمات زیر را وارد نمایید:

```ruby
- job_name: "postgres"
    scrape_interval: "15s"
    static_configs:
          - targets: ['postgres:9187']
```

حال باید کانتینر ها را راه اندازی مجدد نمایید.

```bash
$ docker-compose kill
$ docker-compose up -d
```

خوب دیگه کار تمام شد ، اکنون داخل Prometheus روی پورت ۹۰۹۰ میتوانید پارامترهای مربوط به مانیتورینگ PostgreSQL را مشاهده نمایید.

این آموزش ادامه دارد ، در بخش بعدی آموزش مربوط به اتصال Grafana به Prometheus را خواهیم داشت...
