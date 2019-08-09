### Geospatial

Redis uses the technique of geo hashing to store geospatial points.
```
GEOADD geopoints -117.826508  33.684566 "Irvine" -74.005974 40.712776 "NewYork" -120.740135 47.751076 “Washington”
ZRANGE geopoints 0 -1 WITHSCORES
GEOPOS geopoints NewYork Irvine
geohash geopoints NewYork // returns a geohash reference - http://geohash.org/dr5regw3pg0
type geopoints // zset
```
Internally Redis uses the Sorted Set to store Geospatial objects. Redis computes a Geohash from the Latitude and Longitude. This is a 52 bit number, which can be safely stored in a score of a Sorted Set (which is a double).

To remove a Geospatial object from this Sorted Set we use `ZREM`.

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
```
When a Redis command is executed via `redis.call`, and that command causes an error to be raised, then the script is terminated.
If `redis.pcall` was used instead, the error is returned to the Lua script, so that it can be handled programmatically.

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

The reason to use `register_script` in Python is that it will optimize script execution by invoking EVALSHA when the script is invoked more than once.

Lua uses the `double-equal` operator (==) for comparisons and the keyword `and` for the boolean AND operation.

To iterate over a Lua list, you need to apply the Lua `ipairs()` function, which creates an iterable object.

When creating a variable in a Redis Lua script, you must always use the `local` keyword. To run a Redis command, you use the build-in `redis.call()` function, passing in the name of the Redis command you want to run.






