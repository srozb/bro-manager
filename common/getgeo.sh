#!/bin/sh -e 

#getgeo.sh script taken from: https://github.com/bro/bro-docker/blob/master/common/getgeo.sh

echo "2015-01-23"

mkdir -p /usr/share/GeoIP/

curl -o GeoLiteCity.dat.gz  http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
zcat GeoLiteCity.dat.gz > GeoIP.dat.new
mv GeoIP.dat.new /usr/share/GeoIP/GeoIPCity.dat
rm GeoLiteCity.dat.gz

curl -o GeoLiteCityv6.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
zcat GeoLiteCityv6.dat.gz > GeoIPCityv6.dat
mv GeoIPCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat
rm GeoLiteCityv6.dat.gz

#wget -N http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
#zcat GeoIPASNum.dat.gz > GeoIPASNum.dat
#mv GeoIPASNum.dat /usr/share/GeoIP/GeoIPASNum.dat
