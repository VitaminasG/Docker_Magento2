#!/bin/bash

ROOT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$ROOT_DIR/../.env"

docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti $D_PROJECT_NAME"_"$1 bash
