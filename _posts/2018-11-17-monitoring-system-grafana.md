---
layout: post
title: آموزش کانفیگ سیستم مانیتورینگ - Grafana
category: آموزشی
postimg: /images/post/prometheus-grafana.jpg
tags: [monitoring,prometheus,devops,docker,linux,sysadmin,مانیتوریگ,لینوکس,مدیریت]
---
<p align="center"><img src="/images/post/prometheus-grafana.jpg" alt="Monitoring Prometheus Grafana" /></p>
### گرافانا چیست؟
تا حالا شده یک سری دیتا داشته باشید و بخواهید نمودار برای دیتاهاتون رسم کنید؟ خوب Grafana دقیقا برای شما ساخته شده ولی در کنار این امکان کلی امکانات دیگه در اختیار شما قرار میدهد، مثلا شما میتوانید برای دیتا هاتون Alert تعریف کنید و اعلانات را از طریق ایمیل ، تلگرام و ... دریافت کنید.

راستی Grafana متن باز هم هست و در صورت تمایل می‌توانید روی پروژه مشارکت داشته باشید. [پیوند](https://github.com/grafana/grafana)

در مطلب قبل آموزش نصب و پیکربندی Prometheus را توضیح دادم یعنی در حال حاضر ما یکسری دیتا داریم که قصد داریم برای آنها گراف رسم کنیم.

### تنظیمات Docker compose:
به سرویس‌های فایل docker-compose.yml ای که داریم تنظیمات زیر را اضافه می‌کنیم:

```ruby
grafana:
    image: grafana/grafana
    restart: always
    ports:
       - "3000:3000"
    depends_on:
      - prom
    links:
      - prom:prom
    volumes:
      - "/your-path-to-volume/data/:/var/lib/grafana/"
      - "/your-path-to-volume/config/grafana.ini:/etc/grafana/grafana.ini"
      - "/your-path-to-volume/log/:/var/log/grafana/"
```

- برای grafana.ini ایجاد یک فایل خالی کافی است ، در آینده میتوانید کانفیگ‌های خود را در این فایل بنویسید.
- کل دایرکتوری های ساخته شده باید توسط کاربر و گروه 472 قابل نوشتن باشد.

حال باید یکبار Docker compose را راه‌اندازی مجدد کنیم، الان با استفاده از پورت ۳۰۰۰ به گرافانا دسترسی داریم نام کاربری و رمز عبور پیشفرض admin می باشد.

از بخش Configuration وارد صفحه Data source می‌شویم و روی Add ... کلیک می‌کنیم، نوع آن را Prometheus قرار میدهیم و آدرس سرویس خودمان را می‌دهیم که در اینجا برای ما prom:9090 می‌باشد.

برای PostgreSQL می‌توانید از داشبورد شماره [455](https://grafana.com/dashboards/455) استفاده کنید.

پیشنمایش:

![Demo](/images/post/grafana-pgsql.png)

این آموزش ادامه دارد ...