#! /bin/bash

alias ix="curl -F 'f:1=<-' ix.io"
gclone() { git clone "https://github.com/$1" $2 $3 $4 $5 $6 $7 $8 $9; }
gco () { git checkout $1; }

rm -rf test
mkdir test
cd test

gclone nimterop/nimterop
cd nimterop
gco clifile
nimble develop -y
nimble buildTimeit
nimble bt
cd ..

gclone genotrance/nimpcre
cd nimpcre
nimble develop -y
nimble test
cd ..

gclone genotrance/nimarchive
cd nimarchive
nimble develop -y
nimble test
gco nimteroptest1
nimble test
cd ..

gclone genotrance/nimgit2
cd nimgit2
nimble develop -y
nimble test
gco nimteroptest1
nimble test
cd ..
