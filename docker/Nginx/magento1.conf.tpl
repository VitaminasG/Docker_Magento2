upstream fastcgi_backend {
    server php:9000; # Variables: FPM_HOST and FPM_PORT
}

server {
    listen 80;
    #listen 443 ssl;

    server_name $ENV{"NGINX_HOST"};

    set $MAGE_ROOT /var/www/html;

    # Support for SSL termination.
    set $my_http "http";
    set $my_ssl "off";
    set $my_port "80";
    if ($http_x_forwarded_proto = "https") {
        set $my_http "https";
        set $my_ssl "on";
        set $my_port "443";
    }

    root $MAGE_ROOT;

    index index.php;
    autoindex off;
    charset UTF-8;
    client_max_body_size 100m; # Variable: UPLOAD_MAX_FILESIZE
    error_page 404 403 = /errors/404.php;
    #add_header "X-UA-Compatible" "IE=Edge";

    location ~ (^/(app/\|includes/\|lib/\|/pkginfo/\|var/\|report/config.xml)\|/\.svn/\|/\.git/\|/.hta.+) {
        deny all; #ensure sensitive files are not accessible
    }

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }


    location ~ .php/ {   ## This was apparently the solution due to others but not for me
        rewrite ^(.*.php)/ $1 last;
    }

    location ~ .php$ {
        try_files $uri =404; # if reference to php executable is invalid return 404
        expires off; # no need to cache php executable files
        fastcgi_pass   fastcgi_backend;
        fastcgi_buffers 1024 4k;

        fastcgi_param  PHP_FLAG  "session.auto_start=off \n suhosin.session.cryptua=off";
        fastcgi_param  PHP_VALUE "memory_limit=768M \n max_execution_time=18000";
        fastcgi_read_timeout 600s;
        fastcgi_connect_timeout 600s;

        # Magento uses the HTTPS env var to detrimine if it is using SSL or not.
        fastcgi_param  HTTPS $my_ssl;

        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
        
        fastcgi_param MAGE_RUN_CODE default; # Store code is defined in administration > Configuration > Manage Stores
        fastcgi_param MAGE_RUN_TYPE store;
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
}
