---
layout: post
title: آموزش کانفیگ سیستم مانیتورینگ - Nginx
category: آموزشی
postimg: /images/post/nginx-logo.png
tags: [monitoring,prometheus,devops,docker,linux,sysadmin,مانیتوریگ,لینوکس,مدیریت]
---
<p align="center"><img src="/images/post/nginx-logo.png" alt="Monitoring Prometheus Grafana Nginx" /></p>
قسمت سوم آموزش کانفیگ سیستم مانیتورینگ رو شروع میکنیم با آموزش مانیتور کردن Nginx.

یک ماژول هست به اسم [nginx-module-vts](https://github.com/vozlt/nginx-module-vts) که دیتا های لازم برای مانیتور کردن Nginx را در اختیار ما قرار میدهد، در ابتدای کار باید این ماژول را نصب کنیم که نصب آن نیز به این صورت است:

در توزیع اوبونتو ابتدا لازم است تا پیشنیازهای آن را نصب کنیم:

```bash
$ sudo apt install -y build-essential git tree
$ sudo apt install -y perl libperl-dev libgd3 libgd-dev libgeoip1 libgeoip-dev geoip-bin libxml2 libxml2-dev libxslt1.1 libxslt1-dev
```

سپس ماژول مربوطه را Clone می‌کنیم:

```bash
$ git clone git://github.com/vozlt/nginx-module-vts.git
```

حال باید سورس Nginx را برای لینوکس دانلود کنیم [پیوند](http://nginx.org/download/) و بعد از خارج کردن از حالت فشرده وارد دایرکتوری آن می‌شویم و دستورات زیر را اجرا میکنیم:

```bash
./configure \
    --user=nginx \
    --group=nginx \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-pcre \
    --with-file-aio \
    --with-http_realip_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-http_fastcgi_module \
    --add-module=/path/to/nginx-module-vts
```

- توجه کنید که خط آخر دستور بالا باید آدرس دایرکتوری ماژولی که Clone کرده‌اید را وارد نمایید.

و سپس:

```bash
$ make
$ sudo make install
```

کامپایل Nginx هم به پایان رسید، حال به مرحله‌ی پیکربندی میرسیم.
تنظیمات Nginx خود را باید به صورت زیر انجام دهید:

```
http {
    vhost_traffic_status_zone;
    ...
    server {
        ...
        location /status {
            vhost_traffic_status_display;
            vhost_traffic_status_display_format html;
        }
    }
}
```

حال برای دریافت دیتا توسط Prometheus باید از exporter مربوط به این کار استفاده کنیم.

روی سروری که Nginx نصب است بااستفاده از دستور زیر کانتینر مربوط به exporter را راه اندازی میکنیم:

```bash
$ docker run  --restart always  --net host --env NGINX_STATUS="http://localhost/status/format/json" -d --name nginx-prometheus-exporter sophos/nginx-vts-exporter
```

حال روی پورت ۹۹۱۳ می‌توانیم به این exporter دسترسی داشته باشیم.

الان نوبت به تنظیمات Prometheus برای اتصال به این exporter رسیده ، فایل prometheus.yml را باز می‌کنیم و تنظیمات زیر را در آن قرار میدهیم:

```yaml
- job_name: "nginx-exporter"
    scrape_interval: "15s"
    static_configs:
        - targets: ['localhost:9913']
```

- مقدار لوکال هاست باید با آدرس Nginx جایگزین گردد.

کار تقریبا تمام است فقط برای رسم نمودار برای دیتا ها ، ما از Grafana استفاده می‌کردیم که در اینجا باید داشبورد مربوط به این ماژول [2949](https://grafana.com/dashboards/2949) را نیز نصب کنیم.

![Demo](/images/post/nginxchart.png)