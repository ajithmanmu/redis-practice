### Geospatial

Redis uses the technique of geo hashing to store geospatial points.
```
GEOADD geopoints -117.826508  33.684566 "Irvine" -74.005974 40.712776 "NewYork" -120.740135 47.751076 “Washington”
ZRANGE geopoints 0 -1 WITHSCORES
GEOPOS geopoints NewYork Irvine
geohash geopoints NewYork // returns a geohash reference - http://geohash.org/dr5regw3pg0
```

Redis uses Haversine formula for computing distance between 2 coordinates.

```
GEODIST geopoints NewYork Irvine mi
GEORADIUS geopoints -0.127758 51.507351 4000 mi withdist
GEORADIUS geopoints -0.127758 51.507351 40000 mi count 1 withdist desc // To get the farthest point from the current location
GEORADIUSBYMEMBER geopoints "Irvine" 1000 mi withcoord // Get locations based on a member
```