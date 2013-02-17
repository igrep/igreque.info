#!/bin/bash

./hakyll build

rsync -av -e"ssh -p 49620" _site/ bklx@igreque.info:/var/www/the/_site/

git push
