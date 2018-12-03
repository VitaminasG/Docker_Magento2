#!/bin/bash

# Replace variables $ENV{<environment varname>}
function ReplaceEnvironmentVariable() {
    grep -rl "\$ENV{\"$1\"}" $3|xargs -r sed -i "s|\\\$ENV{\"$1\"}|$2|g"
}

for filename in /etc/nginx/conf.d/*.conf.tpl; do
    # rename *.conf.tpl files into *.conf
    cp -f ${filename} ${filename:0:-4};

    # Replace all variables
    for _curVar in `env | awk -F = '{print $1}'`;do
        # awk has split them by the equals sign
        # Pass the name and value to our function
        ReplaceEnvironmentVariable ${_curVar} ${!_curVar} ${filename:0:-4}
    done

    wait
done

exec /usr/sbin/nginx
