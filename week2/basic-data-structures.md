### Week 2 - Capped Collections and Set operations

#### Lists
Use case: Activity Stream (L/RPUSH + LTRIM)

`LTRIM` key start stop // start is the index from left. stop is the index from right. If stop is negative then count to left. It specify the elements that are being retained.
```
rpush list-1 a b c d e f
ltrim list-1 0 3
lrange list-1 0 -1
ltrim list-1 1 -1
```

#### Sorted Sets
Use case: LeaderBoard (ZADD + ZREMRANGEBYRANK)

`ZREMRANGEBYRANK` key start stop // Specify Elements are being removed
```
// zinterstore
zadd sales-judo 10 AJ 15 Ch 20 OM 23 MAN
zadd sales-wrestling 30 LEL 35 OM 40 MAN
zinterstore promo-taekwondo 2 sales-wrestling sales-judo aggregate sum
zrange promo-taekwondo 0 -1 withscores
```
```
SUNION - to find unique values in multiple sets
SUNIONSTORE,ZUNIONSTORE - to store the result of the operation in a key.
ZUNIONSTORE and ZINTERSTORE allow input keys to be Sorted Sets and Sets. If the WEIGHT parameter is not supplied, then a default value of 1 is used for the score.
ZINTERSTORE and ZUNIONSTORE provide MAX, MIN and SUM aggregation functions only.
```

#### Use case: Faceted Search
A faceted search is a technique that allows simple navigation of a classification using multiple filters and criteria. Another name for this is an inverted index.
Redis has no native support for Compound or Secondary Indexes. 



