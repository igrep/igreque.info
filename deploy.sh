#!/bin/bash

stack exec hakyll -- build

rsync -duav -e"ssh -p 49620" _site/ bklx@igreque.info:/var/www/the/_site/

git push
