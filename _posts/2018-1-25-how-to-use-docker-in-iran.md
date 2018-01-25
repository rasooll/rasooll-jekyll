---
layout: post
title: عبور از تحریم‌های داکر روی گنو/لینوکس
category: آموزشی
postimg: 
tags: [docker,wordpress,container,filter,privoxy,proxychains,socks,wp,dockerhub,داکر,وردپرس,داکرهاب,کانتینر]
---
دیروز داخل وبلاگم پستی نوشتم درباره‌ی نصب وردپرس توسط داکر ، یکی از مشکلاتی که ما ایرانی ها برای استفاده از داکر داریم این هست که ما تحریم هستیم و داکر سرویس‌های خودش را در اختیار ما قرار نمیده خوب این مشکل با هر نوع روش تغییر آیپی باید حل بشه اما روی گنو لینوکس برای عبور داکر از پروکسی باید از ابزار proxychains استفاده کرد اما داکر این ابزار را دور میزنه و ارتباط مستقیم روی سرور خودش ایجاد میکنه درنتیجه تحریم ها دور زده نمیشه و باقیست!
<blockquote dir="ltr" style="font-family: Helvetica,Arial,sans-serif;"> 403 Forbidden<br />
Since Docker is a US company, we must comply with US export control regulations. In an effort to comply with these, we now block all IP addresses that are located in Cuba, Iran, North Korea, Republic of Crimea, Sudan, and Syria. If you are not in one of these cities, countries, or regions and are blocked, please reach out to https://support.docker.com </blockquote>
خوب دیگه الان وقتشه تحریم ها را دور بزنیم !

داکر این امکان را داره که پروکسی http و https برای اتصال به سرور استفاده کنیم اما اگر پروکسی ما ساکس بود باید چه کاری انجام داد ؟

راه حل privoxy هست با استفاده از دستور زیر روی اوبونتو آنرا نصب میکنیم:
```bash
$ sudo apt install privoxy
```
حال باید تنظیمات زیر را داخل فایل تنظیمات وارد کنیم:
```bash
/etc/privoxy/config  # آدرس فایل تنظیمات

forward-socks5t   /               127.0.0.1:1080 .
forward         192.168.*.*/     .
forward            10.*.*.*/     .
forward           127.*.*.*/     .
forward           localhost/     .
```
* در اینجا آدرس ساکس پروکسی شما روی لوکال هاست و پورت ۱۰۸۰ بوده است.

حال باید سرویس privoxy را راه اندازی مجدد کنیم.
```bash
$ sudo systemctl restart privoxy
```
الان ما یک سرویس http پروکسی داریم که روی لوکال هاست و پورت ۸۱۱۸ تنظیم شده است.

حالا باید این پروکسی را روی داکر تنظیم کنیم.<br />
برای اینکار ابتدا باید شاخه زیر را ایجاد کنیم :
```bash
$ sudo mkdir -p /etc/systemd/system/docker.service.d
```
حال فایل ‍`http-proxy.conf` را در شاخه‌ای که ساخته‌ایم ایجاد کرده و تنظیمات زیر را داخلش قرار می‌دهیم:
```bash
[Service]
Environment="HTTP_PROXY=http://localhost:8118/"
```
حالا دستورات زیر را به ترتیب وارد می‌کنیم:
```bash
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```
کار به اتمام رسید ولی با دستور زیر میتوانیم تنظیمات را چک کنیم:
```bash
$ systemctl show --property=Environment docker
Environment=HTTP_PROXY=http://localhost:8118/
```
اگر خروجی به صورت بالا بود تنظیمات به درستی انجام شده و اکنون شما تحریم های داکر را دور زده‌اید و میتوانید از بسته‌های Docker Hub استفاده کنید.
