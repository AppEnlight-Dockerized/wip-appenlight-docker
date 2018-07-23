#!/usr/bin/env bash


sudo apt-get install \
     # https://cryptography.io/en/latest/installation/
     build-essential libssl-dev libffi-dev python3-dev \
     # PgSQL
     libpq-dev \
     # lxml
     libxml2-dev libxslt1-dev

virtualenv -p /usr/bin/python3.6 venv

source venv/bin/activate

pip install --upgrade pip setuptools
pip install -r https://zopefoundation.github.io/Zope/releases/4.0b5/requirements-full.txt
pip install -U -r requirements.txt
pip install -U colander
pip install -U pyramid_debugtoolbar pyramid_tm pyramid_jinja2 jira

cd sources

git clone https://github.com/AppEnlight/appenlight.git -b stable
git clone https://github.com/AppEnlight/appenlight-uptime-ce.git -b stable
git clone https://github.com/AppEnlight/channelstream.git -b stable

cd appenlight/backend
cp ../README.md ./
echo > requirements.txt
pip install .

cd ../../appenlight-uptime-ce/backend
echo > requirements.txt
pip install .

cd ../../channelstream/
pip install .

# Nie instalują się `static` i `templates
# Nie instalują się sources/appenlight-uptime-ce/backend/src/ae_uptime_ce/migrations
# Nie instalują się sources/appenlight-uptime-ce/backend/src/ae_uptime_ce/static


cd ../../..

appenlight-make-config --dbstring postgresql://postgres:changeme@127.0.0.1:5432/postgres --domain 127.0.0.1:6543 production.ini



docker run --user 1000 -v ${PWD}:/node -p 8080:8080 --name crossbar --rm -it crossbario/crossbar
