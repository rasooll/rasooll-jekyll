---
layout: page
title: تماس با من
permalink: /contact/
---
اگر پیشنهاد ، انتقاد ، پیام و یا سفارش انجام کاری دارید می‌توانید با استفاده از فرم زیر برای من ارسال کنید

---

<br>
<form action="https://dynamic.rasooll.com/forms/contact/" method="POST">
  <div class="form-group">
    <label for="name">نام و نام خانوادگی</label>
    <input type="text" class="form-control" id="name" name="name" required>
  </div>
  <div class="form-group">
    <label for="email">آدرس ایمیل</label>
    <input type="email" class="form-control" id="email" name="email" aria-describedby="emailHelp" placeholder="your-name@example.com" required>
    <small id="emailHelp" class="form-text text-muted">هرگز منتشر نخواهد شد و فقط برای تماس با شما استفاده خواهد شد.</small>
  </div>
  <div class="form-group">
    <label for="subject">موضوع پیام</label>
    <input type="text" class="form-control" id="subject" name="subject" required>
  </div>
  <div class="form-group">
    <label for="message">متن پیام</label>
    <textarea name="message" id="message" class="form-control" rows="5" required></textarea>
  </div>
  <div class="form-group">
    <script src='https://www.google.com/recaptcha/api.js?hl=fa'></script>
    <div class="g-recaptcha" data-sitekey="6LdNCWQUAAAAACrxKtIaxXtc22dsUvfrqp5HWwWj"></div>
  </div>
  <button type="submit" class="btn btn-dark">ارسال</button>
</form>
