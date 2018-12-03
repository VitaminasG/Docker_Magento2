server {
    listen 80;
    server_name  mail.$ENV{"NGINX_HOST"};
    rewrite ^ http://mail.$ENV{"NGINX_HOST"}:8025 permanent;
}
