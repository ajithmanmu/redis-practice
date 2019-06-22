### Week 1 - Basic Redis Data Structures

Logical databases provide separation of key names. i.e same key name can appear in multiple logical databases. Redis do not. 
It avoids the complexity of namespace management.
A logical database is identified by a zero-based index. The default is database 0.
Redis uses database 0. 
Redis keys are case sensitive. This is because key name is a binary sequence.

DEL - removes memory associated
UNLINK  - removes memory as an async process. Hence it is unblocking.
NX parameter in SET is used to check for existence of key in Redis.

Lists are stored in memory as below:
<Image>

Keys and Scan difference: 
<Image>

// Commands used
SET customer:1000 jeff
SET customer:1001 dana
SCAN 0 MATCH customer:1* COUNT 10000
UNLINK customer:1000

// NX parameter usage
SET inventory:womens-100-meter-final 1000 NX
SET inventory:womens-100-meter-final "Sold Out" NX
GET inventory:womens-100-meter-final
SET inventory:womens-100-meter-final 0 XX //Use XX to overwrite the value

SET seat-hold Row-A PX 50000 //expiry in ms
SET seat-hold Row-A EX 50 //expiry in seconds
persist seat-hold // to remove the ttl

String datatype can store upto 512 MB. This is the basic format for storage in Redis.
SET inventory:4x100-womens-final 1000
GET inventory:4x100-womens-final --> "1000" //returns as a string
DECRBY inventory:4x100-womens-final 1 // Returns (integer) 999 // Redis checks the encoding of the value stored and does the decrement operation
GET inventory:4x100-womens-final // Returns "999" //However the decremented value would be stored as string
object encoding inventory:4x100-womens-final // "int" // object command to get the encoding of the value stored
Redis supports polymorphism. i.e same key can have values with different datatypes

Hashes - A mini key value store within a Redi Key. Only single level is supported. So no nested fields. Use case - Rate limiting and session stores.
HSET event:juda capacity 1000 location "Atlanta" ticket_price 100USD
HEXISTS event:juda capacity // To check for field existence
Other commands that can maipulate a field: HGET, HDEL, HINCRBY, HGETALL, HSCAN, HMGET

By default Redis will always create a field and a key if either do not exist.

Lists - Ordered collection of strings. Allows duplicate. Redis implements lists as a doubly linked lists. See diagram. Use cases - Activity stream
Used to implement Stacks and Queues. Can do insert/delete at left or right of a list.
Queue implementaion - Use RPUSH and LPOP
LPUSH, RPUSH // insert list element
LPOP, RPOP //delete list element
LPUSH orders:4x100m-womerns-final jane:4 charlie:8 bill:7
LLEN orders:4x100m-womerns-final // (integer) 3
LRANGE orders:4x100m-womerns-final 0 -1 //start and stop index
1) "bill:7"
2) "charlie:8"
3) "jane:4"

rpush list-two a b c d
lrange list-two 0 -1 // returns "a" "b" "c" "d"
lpop list-two //returns "a"
lindex list-two 1 // returns "c"

Sets are unordered collection of unique strings. Use case - Tag Cloud, Tracking Unique visitors (Using SADD, SCAN, EXPIRE)
SADD, SMEMBERS, SSCAN, SPOP
SADD venues "Tokyo Stadium" "Atlanta Stadium" "California"
SSCAN venues 0 MATCH *

SADD fruits_basket_1 "apple" "orange" "banana"
SADD fruits_basket_2 "papaya" "apple" "pineapple"
SDIFF - Returns the difference between sets // "orange" "banana" // SDIFF performs a logical subtraction from the first Set with the subsequent Sets given.
SINTER - Returns intersection betwenn sets // "apple"
SUNION  - Returns all unique values between sets // "apple" "orange" "pineapple" "banana" "papaya"

Sorted Sets - Ordered collection of unique strings.
Each element has a floating point score to determine the sort order. If score is same then lexical value of the element is used.
ZADD, ZRANGE, ZREVRANGE, ZSCORE, ZRANK, ZCOUNT, ZREM
ZADD student_rankings 5 AJ  2 CH 1 OM 10 SAJ 10 MAN
ZRANGE student_rankings 0 -1 WITHSCORES
The rank is the absolute position of the element within the Sorted Set. Its a zero based integer index.
ZINTERSTORE, ZUNIONSTORE - Sorted sets provide the ability to perform an intersection and union but not a difference.
Use cases: Leaderboard, Priorith Queue
