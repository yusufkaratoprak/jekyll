#!/bin/bash

# PR degilse calistir.
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "PR Gonderildi. Cikiliyor"
  exit 0
fi

# hatalari goster
set -e

# derle bro
echo "+===================================+"
echo "Site Olusturuluyor"
echo "+===================================+"

bundle exec rake build

echo "+===================================+"
echo "Statik Dosyalar Olusturuldu"
echo "+===================================+"

# temizlik
rm -rf ../yusufkaratoprak.github.io.master

#master branch clone islemi
git clone https://${GH_TOKEN}@github.com/yusufkaratoprak/yusufkaratoprak.github.io.git ../yusufkaratoprak.github.io.master

# master branch tasima islemi
cp -R _site/* ../yusufkaratoprak.github.io.master

# Dizine gir
echo "+===================================+"
echo "Dizine Geciliyor"
echo "+===================================+"

cd ../yusufkaratoprak.github.io.master
touch .nojekyll

#Gitignore olustur
echo "+===================================+"
echo "Gitignore Olusturuluyor"
echo "+===================================+"

cat >.gitignore <<EOF
.ruby-version
.bundle
.sass-cache
.jekyll-metadata
Gemfile.lock
EOF

echo "+===================================+"
echo "Gitignore Olusturuldu"
echo "+===================================+"

#CNAME Olustur
echo "+===================================+"
echo "CNAME Olusturuluyor"
echo "+===================================+"

echo yusufkaratoprak.com > CNAME

echo "+===================================+"
echo "CNAME Olusturuldu"
echo "+===================================+"

#biraz bekle
sleep 2

#Githuba gonder
echo "+===================================+"
echo "Githuba Gonderiliyor"
echo "+===================================+"

git config user.email "yusufkaratoprak@gmail.com"
git config user.name "yusufkaratoprak"
git add -A .
git commit -a -m "Generated Jekyll site by Travis CI #$TRAVIS_BUILD_NUMBER"

#guvenlik icin push ciktisi gosterilmeyecek
git push --quiet origin master > /dev/null 2>&1

echo "+===================================+"
echo "Githuba Gonderildi"
echo "+===================================+"