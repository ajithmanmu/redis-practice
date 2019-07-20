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

### Lua Scripting

  -Wrap Redis command with Lua
 - Reduce network traffic
 - Similar to Stored Procedures
 - treated as an Atomic unit of work

```
EVAL lua_script
redis.call // fails if there is an error
redis.pcall // returns the error 
```

```
hset hash_key field1 "apple" field2 “orange"
eval "return redis.call('HGET', KEYS[1], ARGV[1])" 1 hash_key field2
```

Redis will truncate a Lua number, removing anything after the decimal point. If you need to preserve a floating point number, then pass back to Redis as a String.


`SCRIPT LOAD lua_script` //The SCRIPT LOAD command takes a given script, parses it, and then returns the script's hash digest.This can be used for frequently used scripts.

Then invoke the script using `EVALSHA` command.
```
SET test_val “Apple"
script load "local val=redis.call('GET', KEYS[1]) return val”
evalsha "dd47ad79bb7b6d7d2b8e0607c344d134412e84e0" 1 test_val
```
![Lists](./lua.png?raw=true "Lists")


