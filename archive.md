---
layout: default
title: آرشیو
permalink: /archive/
---
<section class="archive-post">

   {% for post in site.posts %}
       {% assign currentDate = post.date | jdate: "%Y" %}
       {% if currentDate != myDate %}
           {% unless forloop.first %}</ul>{% endunless %}
           <h1>{{ currentDate }}</h1>
           <div>
           {% assign myDate = currentDate %}
       {% endif %}
       <p><span class="date" style="margin-left: 8px;">{{ post.date | jdate: "%d / %m" }}</span><a href="{{ post.url }}">{{ post.title }}</a></p>
       {% if forloop.last %}</div>{% endif %}
   {% endfor %}

</section>
