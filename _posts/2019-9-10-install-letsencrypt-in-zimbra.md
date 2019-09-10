---
layout: post
title: آموزش استفاده از گواهی LetsEncrypt SSL در ایمیل سرور Zimbra
category: آموزشی
postimg: /images/post/zimbra-letsencrypt1.png
tags: [SSL,LetsEncrypt,Zimbra,Email,Server]
---
<p align="center"><img src="/images/post/zimbra-letsencrypt1.png" alt="zimbra-letsencrypt1" /></p>
سلام، امروز میخواهیم با همدیگه در ایمیل سرور Zimbra یک گواهی SSL از نوع LetsEncrypt نصب کنیم، کار خیلی آسونی هست بریم که انجامش بدیم.

> **نکته:** در Zimbra Server نسخه ۸.۷ و بالاتر برخی دستورات با کاربر zimbra انجام می‌شود، اما در نسخه ۸.۶ و پایین‌تر تمامی این دستورات باید با کاربر root انجام شوند.

ابتدا باید سرویس `zimbraproxy` و `mailboxd` رو متوقف کنیم:

```
$ zmproxyctl stop
$ zmmailboxdctl stop
```

حال نیاز است تا پروژه LetsEncrypt رو داشته باشیم(البته می‌توانید از بسته Certbot نیز با توجه با سیستم عامل یا توزیع خود استفاده کنید).

```
$ git clone https://github.com/letsencrypt/letsencrypt
$ cd letsencrypt
```

الان با استفاده از دستور زیر می‌توانیم برای دامنه مورد نظر خودمون درخواست گواهی SSL بدهیم:

```
# ./letsencrypt-auto certonly --standalone -d xmpp.example.com
```

چون سرویس `zimbraproxy` متوقف شده است یک وب سرور standalone میتواند روی پورت ۸۰ شروع به کار کند برای تایید هویت دامنه شما.

با دیدن خروجی مانند زیر یعنی گواهی SSL شما صادر شده است:

```
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/zimbra86.zimbra.io/fullchain.pem. Your cert
   will expire on 2016-03-04. To obtain a new version of the
   certificate in the future, simply run Let's Encrypt again.
 - If like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

فایل های SSL کجا قرار دارند؟ در مسیر زیر

```
/etc/letsencrypt/live/domainname
```

* که در اینجا domainname همان نام دامنه شماست.

```
root@zimbra86:/etc/letsencrypt/live/zimbra86.zimbra.io# ls -al
total 8
drwxr-xr-x 2 root root 4096 Dec  5 16:46 .
drwx------ 3 root root 4096 Dec  5 16:46 ..
lrwxrwxrwx 1 root root   42 Dec  5 16:46 cert.pem -> ../../archive/zimbra86.zimbra.io/cert1.pem
lrwxrwxrwx 1 root root   43 Dec  5 16:46 chain.pem -> ../../archive/zimbra86.zimbra.io/chain1.pem
lrwxrwxrwx 1 root root   47 Dec  5 16:46 fullchain.pem -> ../../archive/zimbra86.zimbra.io/fullchain1.pem
lrwxrwxrwx 1 root root   45 Dec  5 16:46 privkey.pem -> ../../archive/zimbra86.zimbra.io/privkey1.pem
```

حال شما علاوه بر Intermediate CA نیاز به Root CA نیز دارید که میتوانید آن را از [این لینک](https://www.identrust.com/certificates/trustid/root-download-x3.html) دریافت نمایید.

فایل chain.pem را با یک ویرایشگر متن باز کرده و یک نمونه از Root CA مانند زیر به انتهای فایل خود اضافه کنید.

```
-----BEGIN CERTIFICATE-----
YOURCHAIN
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDSjCCAjKgAwIBAgIQRK+wgNajJ7qJMDmGLvhAazANBgkqhkiG9w0BAQUFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTAwMDkzMDIxMTIxOVoXDTIxMDkzMDE0MDExNVow
PzEkMCIGA1UEChMbRGlnaXRhbCBTaWduYXR1cmUgVHJ1c3QgQ28uMRcwFQYDVQQD
Ew5EU1QgUm9vdCBDQSBYMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AN+v6ZdQCINXtMxiZfaQguzH0yxrMMpb7NnDfcdAwRgUi+DoM3ZJKuM/IUmTrE4O
rz5Iy2Xu/NMhD2XSKtkyj4zl93ewEnu1lcCJo6m67XMuegwGMoOifooUMM0RoOEq
OLl5CjH9UL2AZd+3UWODyOKIYepLYYHsUmu5ouJLGiifSKOeDNoJjj4XLh7dIN9b
xiqKqy69cK3FCxolkHRyxXtqqzTWMIn/5WgTe1QLyNau7Fqckh49ZLOMxt+/yUFw
7BZy1SbsOFU5Q9D8/RhcQPGX69Wam40dutolucbY38EVAjqr2m7xPi71XAicPNaD
aeQQmxkqtilX4+U9m5/wAl0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFMSnsaR7LHH62+FLkHX/xBVghYkQMA0GCSqG
SIb3DQEBBQUAA4IBAQCjGiybFwBcqR7uKGY3Or+Dxz9LwwmglSBd49lZRNI+DT69
ikugdB/OEIKcdBodfpga3csTS7MgROSR6cz8faXbauX+5v3gTt23ADq1cEmv8uXr
AvHRAosZy5Q6XkjEGB5YGV8eAlrwDPGxrancWYaLbumR9YbK+rlmM6pZW87ipxZz
R8srzJmwN0jP41ZL9c8PDHIyh8bwRLtTcm1D9SZImlJnt1ir/md2cXjbDaJWFBM5
JDGFoqgCWjBH4d1QB7wCCZAA62RjYJsWvIjJEubSfZGL+T0yjWW06XyxV3bqxbYo
Ob8VZRzI9neWagqNdwvYkQsEjgfbKbYK7p2CNTUQ
-----END CERTIFICATE-----
```

حال با استفاده از دستورات زیر گواهی SSL خود را به محل نصب Zimbra منتقل می‌کنیم:

```
root@mail2:~# mkdir /opt/zimbra/ssl/letsencrypt
root@mail2:~# cp /etc/letsencrypt/live/mail2.next.zimbra.io/* /opt/zimbra/ssl/letsencrypt/
root@mail2:~# chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*
root@mail2:~# ls -la /opt/zimbra/ssl/letsencrypt/
total 24
drwxr-xr-x 2 root   root   4096 Jul 15 22:59 .
drwxr-xr-x 8 zimbra zimbra 4096 Jul 15 22:59 ..
-rw-r--r-- 1 zimbra zimbra 1809 Jul 15 22:59 cert.pem
-rw-r--r-- 1 zimbra zimbra 2847 Jul 15 22:59 chain.pem
-rw-r--r-- 1 zimbra zimbra 3456 Jul 15 22:59 fullchain.pem
-rw-r--r-- 1 zimbra zimbra 1704 Jul 15 22:59 privkey.pem
```

* توجه داشته باید نام دامنه خود را جایگزین کنید.

حال باید اعتبار گواهی SSL خود را بررسی کنید:

```
zimbra@zimbra87:/opt/zimbra/ssl/letsencrypt/$ /opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem 
** Verifying cert.pem against privkey.pem
Certificate (cert.pem) and private key (privkey.pem) match.
Valid Certificate: cert.pem: OK
```

حال بهتر است که از گواهی های موجود در سرور بکاپ بگیریم، به هر حال بکاپ هیچوقت ضرر نداره.

```
cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")
```

حال باید Private key مربوط به SSL خودمون رو کپی کنیم:

```
cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
```

الان می‌تونیم Deploy نهایی رو انجام بدیم:

```
zimbra@mail2://opt/zimbra/ssl/letsencrypt/$ /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem 
** Verifying 'cert.pem' against '/opt/zimbra/ssl/zimbra/commercial/commercial.key'
Certificate 'cert.pem' and private key '/opt/zimbra/ssl/zimbra/commercial/commercial.key' match.
** Verifying 'cert.pem' against 'chain.pem'
Valid certificate chain: cert.pem: OK
** Copying 'cert.pem' to '/opt/zimbra/ssl/zimbra/commercial/commercial.crt'
** Copying 'chain.pem' to '/opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt'
** Appending ca chain 'chain.pem' to '/opt/zimbra/ssl/zimbra/commercial/commercial.crt'
** Importing cert '/opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt' as 'zcs-user-commercial_ca' into cacerts '/opt/zimbra/common/lib/jvm/java/jre/lib/security/cacerts'
** NOTE: restart mailboxd to use the imported certificate.
** Saving config key 'zimbraSSLCertificate' via zmprov modifyServer mail2.next.zimbra.io...failed (rc=1)
** Installing ldap certificate '/opt/zimbra/conf/slapd.crt' and key '/opt/zimbra/conf/slapd.key'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.crt' to '/opt/zimbra/conf/slapd.crt'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.key' to '/opt/zimbra/conf/slapd.key'
** Creating file '/opt/zimbra/ssl/zimbra/jetty.pkcs12'
** Creating keystore '/opt/zimbra/mailboxd/etc/keystore'
** Installing mta certificate '/opt/zimbra/conf/smtpd.crt' and key '/opt/zimbra/conf/smtpd.key'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.crt' to '/opt/zimbra/conf/smtpd.crt'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.key' to '/opt/zimbra/conf/smtpd.key'
** Installing proxy certificate '/opt/zimbra/conf/nginx.crt' and key '/opt/zimbra/conf/nginx.key'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.crt' to '/opt/zimbra/conf/nginx.crt'
** Copying '/opt/zimbra/ssl/zimbra/commercial/commercial.key' to '/opt/zimbra/conf/nginx.key'
** NOTE: restart services to use the new certificates.
** Cleaning up 3 files from '/opt/zimbra/conf/ca'
** Removing /opt/zimbra/conf/ca/41b01cbb.0
** Removing /opt/zimbra/conf/ca/ca.key
** Removing /opt/zimbra/conf/ca/ca.pem
** Copying CA to /opt/zimbra/conf/ca
** Copying '/opt/zimbra/ssl/zimbra/ca/ca.key' to '/opt/zimbra/conf/ca/ca.key'
** Copying '/opt/zimbra/ssl/zimbra/ca/ca.pem' to '/opt/zimbra/conf/ca/ca.pem'
** Creating CA hash symlink '41b01cbb.0' -> 'ca.pem'
** Creating /opt/zimbra/conf/ca/commercial_ca_1.crt
** Creating CA hash symlink '4f06f81d.0' -> 'commercial_ca_1.crt'
** Creating /opt/zimbra/conf/ca/commercial_ca_2.crt
** Creating CA hash symlink '2e5ac55d.0' -> 'commercial_ca_2.crt'
```

حال یکبار لازم است تا سرور Zimbra راه اندازی مجدد گردد:

```
zmcontrol restart
```

کار تمام شد الان میتوانیم آدرس ایمیل سرور خودمون رو باز کنیم و صفحه زیر را ببینیم

![Zimbra login](/images/post/zimbra-letsencrypt3.png "Zimbra login")

گواهی SSL ما نیز به صورت زیر است:

![Zimbra](/images/post/zimbra-letsencrypt2.png "Zimbra")

کار تمام شد
