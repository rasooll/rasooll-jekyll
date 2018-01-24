---
layout: post
title: آموزش نصب وردپرس توسط داکر
category: آموزشی
postimg: /images/post/docker-wp.png
tags: [docker,wordpress,container,wp,dockerhub,داکر,وردپرس,داکرهاب,کانتینر]
---
<p align="center"><img src="/images/post/docker-wp.png" alt="داکر و وردپرس" /></p>
شاید شما هم نیاز داشته باشید تا یک وردپرس در کوتاه ترین زمان بدون نصب و تنظیمات Lamp داشته باشید ، در این زمان است که داکر به کمک شما میاد.<br />
شما توسط داکر می‌توانید مجموعه‌ای از برنامه‌ها را در کنار یکدیگر داشته باشید بدون این که تنظیمات این برنامه ها تداخلی با هم داشته باشند ، خوب دیگه بریم سراغ نصب وردپرس.

فرض بر این داریم که داکر روی سیستم شما نصب است ، اما اگر نیست به این [پیوند](https://docker.com){:target="_blank"} مراجعه کنید.

برای شروع باید ‌دیتابیس ماریا را نصب کنیم برای اینکار از دستور زیر استفاده می‌کنیم.
```bash
docker pull mariadb
```
پس از نصب دیتابیس باید خود وردپرس را نصب کنیم.
```bash
docker pull wordpress
```
* توجه داشته باشید دستورات داکر باید با دسترسی `sudo` اجرا شوند.

حال ما هم دیتابیس در اختیار داریم و هم وردپرس ، اکنون به دو عدد پوشه نیاز داریم تا فایل های وردپرس و دیتابیس هایمان را در آنها ذخیره کنیم. فرض می‌کنیم آدرس پوشه‌های ما به صورت زیر است:
```bash
/home/rasool/www  # برای فایل های وردپرس 
/home/rasool/mysql # برای ذخیره دیتابیس 
```
ابتدا باید سرویس mysql را اجرا کنیم توسط دستور زیر:
```bash
docker run -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_USER=dbuser -e MYSQL_PASSWORD=dbpassword -e MYSQL_DATABASE=dbname -v /home/rasool/mysql:/var/lib/mysql --name some-mariadb-name -d mariadb
```
در دستور فوق برای متغییرهای زیر مقدار مورد نظر را می‌کنیم:
* MYSQL_ROOT_PASSWORD : رمز عبور روت برای دیتابیس
* MYSQL_USER : نام کاربری برای دیتابیس
* MYSQL_PASSWORD :  رمز عبور برای نام کاربری ساخته شده
* MYSQL_DATABASE : نام مورد نظر برای دیتابیس

حال باید وردپرس را اجرا کنیم :
```bash
docker run -e WORDPRESS_DB_USER=dbuser -e WORDPRESS_DB_PASSWORD=dbpassword -e WORDPRESS_DB_NAME=dbname -p 8081:80 -v /home/rasool/www:/var/www/html --link some-mariadb-name:mysql --name wp-container -d wordpress
```
با توجه به دیتابیسی که در مرحله قبل ساخته‌ایم برای دستور فوق هم اطلاعات دیتابیسمان را وارد می‌کنیم:
* WORDPRESS_DB_USER : نام کاربری برای دیتابیس
* WORDPRESS_DB_PASSWORD : رمز عبور برای نام کاربری ساخته شده
* WORDPRESS_DB_NAME : نام دیتابیس ساخته شده

حال وردپرس ما اجرا شده و از طریق آدرس زیر می‌توانیم به آن دسترسی داشته باشیم :
```bash
http://localhost:8081
```
امیدوارم مفید بوده باشه ، خوش باشید.<br />
