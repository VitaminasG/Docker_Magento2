# This file is created automatically by the docker build

upstream fastcgi_backend {
  server php:9000; # Variables: FPM_HOST and FPM_PORT
}

server {
    listen 80;
    #listen 443 ssl;

    server_name $ENV{"NGINX_HOST"};

    set $MAGE_ROOT /var/www/html;
    set $MAGE_MODE developer;

    # Support for SSL termination.
    set $my_http "http";
    set $my_ssl "off";
    set $my_port "80";
    if ($http_x_forwarded_proto = "https") {
        set $my_http "https";
        set $my_ssl "on";
        set $my_port "443";
    }

    #ssl_certificate /etc/nginx/ssl/magento.crt;
    #ssl_certificate_key /etc/nginx/ssl/magento.key;

    root $MAGE_ROOT/pub;

    index index.php;
    autoindex off;
    charset UTF-8;
    client_max_body_size 100m; # Variable: UPLOAD_MAX_FILESIZE
    error_page 404 403 = /errors/404.php;
    #add_header "X-UA-Compatible" "IE=Edge";

    # PHP entry point for setup application
    location ~* ^/setup($|/) {
        root $MAGE_ROOT;
        location ~ ^/setup/index.php {
            fastcgi_pass   fastcgi_backend;

            fastcgi_param  PHP_FLAG  "session.auto_start=off \n suhosin.session.cryptua=off";
            fastcgi_param  PHP_VALUE "memory_limit=768M \n max_execution_time=600";
            fastcgi_read_timeout 600s;
            fastcgi_connect_timeout 600s;

            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

        location ~ ^/setup/(?!pub/). {
            deny all;
        }

        location ~ ^/setup/pub/ {
            add_header X-Frame-Options "SAMEORIGIN";
        }
    }

    # PHP entry point for update application
    location ~* ^/update($|/) {
        root $MAGE_ROOT;

        location ~ ^/update/index.php {
            fastcgi_split_path_info ^(/update/index.php)(/.+)$;
            fastcgi_pass   fastcgi_backend;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            fastcgi_param  PATH_INFO        $fastcgi_path_info;
            include        fastcgi_params;
        }

        # Deny everything but index.php
        location ~ ^/update/(?!pub/). {
            deny all;
        }

        location ~ ^/update/pub/ {
            add_header X-Frame-Options "SAMEORIGIN";
        }
    }

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location /pub/ {
        location ~ ^/pub/media/(downloadable|customer|import|theme_customization/.*\.xml) {
            deny all;
        }
        alias $MAGE_ROOT/pub/;
        add_header X-Frame-Options "SAMEORIGIN";
    }

    location /static/ {
        if ($MAGE_MODE = "production") {
            expires max;
        }

        # Remove signature of the static files that is used to overcome the browser cache
        location ~ ^/static/version {
            rewrite ^/static/(version\d*/)?(.*)$ /static/$2 last;
        }

        location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$ {
            add_header Cache-Control "public";
            add_header X-Frame-Options "SAMEORIGIN";
            expires +1y;

            if (!-f $request_filename) {
                rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
            }
        }
        location ~* \.(zip|gz|gzip|bz2|csv|xml)$ {
            add_header Cache-Control "no-store";
            add_header X-Frame-Options "SAMEORIGIN";
            expires    off;

            if (!-f $request_filename) {
               rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
            }
        }
        if (!-f $request_filename) {
            rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
        }
        add_header X-Frame-Options "SAMEORIGIN";
    }

    location /media/ {
        try_files $uri $uri/ /get.php$is_args$args;

        location ~ ^/media/theme_customization/.*\.xml {
            deny all;
        }

        location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$ {
            add_header Cache-Control "public";
            add_header X-Frame-Options "SAMEORIGIN";
            expires +1y;
            try_files $uri $uri/ /get.php$is_args$args;
        }
        location ~* \.(zip|gz|gzip|bz2|csv|xml)$ {
            add_header Cache-Control "no-store";
            add_header X-Frame-Options "SAMEORIGIN";
            expires    off;
            try_files $uri $uri/ /get.php$is_args$args;
        }
        add_header X-Frame-Options "SAMEORIGIN";
    }

    location /media/customer/ {
        deny all;
    }

    location /media/downloadable/ {
        deny all;
    }

    location /media/import/ {
        deny all;
    }

    # PHP entry point for main application
    location ~ (index|get|static|report|404|503|adm|test|info)\.php$ {
        try_files $uri =404;
        fastcgi_pass   fastcgi_backend;
        fastcgi_buffers 1024 4k;

        fastcgi_param  PHP_FLAG  "session.auto_start=off \n suhosin.session.cryptua=off";
        fastcgi_param  PHP_VALUE "memory_limit=768M \n max_execution_time=18000";
        fastcgi_read_timeout 600s;
        fastcgi_connect_timeout 600s;
        fastcgi_param  MAGE_MODE $MAGE_MODE;

        # Magento uses the HTTPS env var to detrimine if it is using SSL or not.
        fastcgi_param  HTTPS $my_ssl;

        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    gzip on;
    gzip_disable "msie6";

    gzip_comp_level 6;
    gzip_min_length 1100;
    gzip_buffers 16 8k;
    gzip_proxied any;
    gzip_types
        text/plain
        text/css
        text/js
        text/xml
        text/javascript
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/xml+rss
        image/svg+xml;
    gzip_vary on;

    # Banned locations (only reached if the earlier PHP entry point regexes don't match)
    location ~* (\.php$|\.htaccess$|\.git) {
        deny all;
    }
}
