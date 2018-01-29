---
layout: default
title: آرشیو
permalink: /archive/
---
<section class="archive">

   {% for post in site.posts %}
       {% assign currentDate = post.date | jdate: "%Y" %}
       {% if currentDate != myDate %}
           <h1>{{ currentDate }}</h1>
       {% assign myDate = currentDate %}
       {% endif %}
        <div class="row item">
            <div class="col-3 col-sm-2 font-sahel align-center">
                {{ post.date | jdate: "%d / %m" }}
            </div>
            <div class="col-9 col-sm-10">
                <a href="{{ post.url }}">{{ post.title }}</a>
            </div>
        </div>
   {% endfor %}

</section>
