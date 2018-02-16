#!/bin/bash

cd /src

docker exec $1 ./Console/cake test app $2