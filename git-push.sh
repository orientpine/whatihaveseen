#!/bin/bash
cd /home/oriclaw/whatihaveseen
git add -A
git commit -m "${1:-Add new article}"
git push origin main
