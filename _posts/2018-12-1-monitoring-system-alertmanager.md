---
layout: post
title: آموزش کانفیگ سیستم مانیتورینگ - Alertmanager
category: آموزشی
postimg: /images/post/prometheus-logo.png
tags: [monitoring,prometheus,devops,docker,linux,sysadmin,مانیتوریگ,لینوکس,مدیریت]
---
<p align="center"><img src="/images/post/prometheus-logo.png" alt="Monitoring Prometheus Alertmanager" /></p>
قسمت چهارم از سری آموزش های کانفیگ سیستم مانیتورینگ توسط Prometheus را شروع می‌کنیم.
در این بخش قصد داریم تا Alertmanager را کانفیگ کنیم، تا هر زمانی که مقدار دیتایی که در حال مانیتور کردن آن هستیم از حد مشخصی فاصله گرفت به سرعت با خبر شویم.

### چرا Prometheus Alertmanager ؟

چون قابلیت شخصی سازی بسیار زیادی دارد و تقریبا می‌توان گفت کنترل همه چیز در دستان شماست!
می‌توانید تنظیم کنید برایتان ایمیل ارسال شود یا از طریق تلگرام، Slack و ... شما را مطلع سازد، همچنین قابلیت ارسال Alert از طریق وب هوک به دیگر سیستم‌ها را نیز دارا می‌باشد.

برای یادگیری بهتر این آموزش لازم است تا قسمت‌های قبلی آن را دیده باشید(دسترسی در پایین صفحه)

برای شروع باید فایل docker-compose.yml را ویرایش کنیم و کانتینر مربوط به Alertmanager را اضافه کنیم:

```ruby
alertmanager:
image: quay.io/prometheus/alertmanager:latest
volumes:
- ./alertmanager_volume/alertmanager.yml:/etc/prometheus/alertmanager.yml
- ./alertmanager_volume/data:/data
command:
- '--config.file=/etc/prometheus/alertmanager.yml'
- '--storage.path=/data'
ports:
- 9093:9093
```

- همچنین لازم است تا کانتینر alertmanager در کانتینر prom نیز لینک شود.

سپس یک دایرکتوری به نام alertmanager_volume ایجاد کرده و فایل alertmanager.yml را داخل آن ایجاد میکنیم، محتویات این فایل به صورت زیر است:

```
global:
  # The smarthost and SMTP sender used for mail notifications.
  smtp_smarthost: 'smtp.google.com:587'
  smtp_from: 'your-alerting-email@google.com'
  smtp_auth_username: 'your-alerting-email@gmail.com'
  smtp_auth_password: 'your-password'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
  receiver: 'support-team-email'
receivers:
- name: 'support-team-email'
  email_configs:
      - to: 'your-email-for-get-alert@example.com'
          send_resolved: true
```

حال باید فایل prometheus.yml را که در قسمت اول ساختیم ویرایش نماییم و تنظیمات زیر را به آن اضافه نماییم:alerting:

```
  alertmanagers:
    - static_configs:
      - targets:
        - alertmanager:9093
rule_files:
  - "prometheus.rules.yml"
```

- مقدار alertmanager:9093 همان نامی از که شما زمان لینک کردن alertmanager به prometheus وارد کرده‌اید.

حال در کنار فایل prometheus.yml یک فایل جدید ایجاد می‌کنیم و نام آن را prometheus.rules.yml می‌گذاریم و محتویات آن نیز به صورت زیر می‌نویسیم:

```
groups:
  - name: nginx1
    rules:
        - alert: Active Connection
          expr: nginx_server_connections{instance="xxx.xxx.xxx.xxx:port", status="active"} > 1000
          for: 5m
          labels:
            severity: 2
         annotations:
         summary: "Value: {% raw %}{{ $value }}{% endraw %}, Limit: 100"
         description: "This is a decscription."
```

برای توضیح کد بالا می‌توان گفت اگر کانکشن های active سرور مشخص شده برای ۵ دقیقه بیشتر از ۱۰۰۰ عدد بود برای ما alert ارسال شود.

به همین صورت می‌توانید برای مقادیر مورد نظر خود rule نوشته و از alertmanager استفاده نمایید.

قسمت چهارم از سری آموزش کانفیگ سیستم مانیتورینگ به پایان رسید.