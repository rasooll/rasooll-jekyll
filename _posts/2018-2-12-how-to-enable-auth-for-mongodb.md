---
layout: post
title: آموزش فعالسازی احراز هویت برای MongoDB
category: آموزشی
postimg: /images/post/MongoDB.png
tags: [mongodb,auth,nosql,database,security,username,password,مونگو,مونگودی‌بی,مونگو دی بی,احراز هویت,احراز,هویت]
---
<p align="center"><img src="/images/post/MongoDB.png" alt="MongoDB" /></p>
زمانی که برای بار اول دیتابیس MongoDB را نصب می‌کنیم این دیتابیس هیچگونه پسوردی برای مدیریت ندارد و میتوان به راحتی به دیتابیس‌های آن دسترسی پیدا کرد در این پست قصد دارم نحوه تنظیم کردن نام کاربری و رمز عبور برای این دیتابیس را توضیح دهم ...

ابتدا باید سرویس این دیتابیس را راه اندازی کنیم که با استفاده از دستور زیر این کار امکان پذیر است :
```bash
sudo systemctl start mongod
```
* نکته‌ای که گفتنش ضرری ندارد این این است که به هیچ عنوان نباید دستور `mongod` را با دسترسی ریشه اجرا کرد چون با اینکار به دلیل تغییر کردن سطح دسترسی فایل های مربوط به دیتابیس ، عملکرد راه اندازی این سرویس توسط Systemctl به مشکل خواهد خورد.

حال با استفاده از دستور `mongo` باید وارد شل دیتابیس شویم و سپس دستور `use admin` را وارد می‌کنیم تا وارد دیتابیس admin شویم ، سپس با استفاده از دستور زیر می‌توانیم یک کاربر جدید ایجاد کنیم:
```json
db.createUser(
  {
    user: "myUserAdmin",
    pwd: "abc123",
    roles: [ { role: "root", db: "admin" } ]
  }
)
```
* **user:** در این قسمت باید نام کاربری مورد نظر خودتان را جایگزین myUserAdmin نمایید.
* **pwd:** در این قسمت نیز باید پسورد مورد نظر خود را جایگزین abc123 کنید.

سپس با استفاده از `exit` از شل مربوط به دیتابیس خارج می‌شویم.

حال باید تنظیمات زیر را در فایل `/etc/mongod.conf` قرار دهیم:
```
security:
    authorization: enabled
setParameter:
    enableLocalhostAuthBypass: false
```
اکنون باید سرویس مربوط به دیتابیس را راه اندازی مجدد کنیم:
```bash
sudo systemctl restart mongod
```
زین پس می‌توان با دستور زیر به MongoDB دسترسی داشت:
```bash
mongo --port 27017 -u "myUserAdmin" -p "abc123" --authenticationDatabase "admin"
```

* این آموزش برای اوبونتو نسخه ۱۷.۱۰ تهیه شده است.
