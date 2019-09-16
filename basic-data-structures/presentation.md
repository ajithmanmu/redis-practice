### Redis Data Structures Presentation

Introduction
    
    Overview of Redis
        Redis stands for REmote DIctonary Server. It is a fast, open-source, in-memory key-value data store.
        It can be used as a database, cache, message broker and queue.
        Written in ANSI C.
    
    Why Redis
        Fast:
            Redis works with an in-memory database. By eliminating the need to access disks, in-memory data stores such as Redis avoid seek time delays and can access data in microseconds. They can therefore support an order of magnitude more operations and faster response times. The result is – blazing fast performance with average read or write operations taking less than a millisecond and support for millions of operations per second.
        Flexible Data Structures:
            Unlike simplistic key-value data stores that offer limited data structures, Redis has a vast variety of data structures to meet your application needs. 
        Replication and Persistence:
            Redis employs a primary-replica architecture and supports asynchronous replication where data can be replicated to multiple replica servers. For persistence, Redis supports point-in-time backups (copying the Redis data set to disk) OR using AOF (Append Only File) persistent logs on every write operation.    
        High availability and scalability:
            Provides high availability via Redis Sentinel and automatic partitioning with Redis Cluster. (TODO !!!)
        Extensibility:
            Open source and supported by most of the languages (Node, Java, Python,C...)

    Redis in Surfline
        Session Management - Used by auth-service for storing access tokens and managing the session.
        Caching Layer - Used by legacy systems to store api responses and sometimes HTML content. 

Keys
    - Binary safe
    - Case Sensitive - This is because key name is a binary sequence
    - Supports ploymorphism - same key can have values with different dataypes
    - An empty string is also a valid key

Run Redis Docker Locally:
    docker run -d -p 6379:6379 --name redis1 redis
    docker exec -it redis1 sh
    redis-cli

DEL and UNLINK // TODO
    `DEL` - removes memory associated
    `UNLINK`  - removes memory as an async process. Hence it is unblocking.
Atomicity in Redis // Todo
    All redis commands are atomic since it is single threaded.
What is redis.conf file // TODO
    This is the default configuration file
SCAN and KEYS // TODO
    KEYS - Blocking , do not use in prod
    SCAN - iterates using a cursor.
        SET customer:1000 jeff
        SET customer:1001 dana
        SCAN 0 MATCH customer:1* COUNT 10000
What is Sharding
        

Data Structures

    Strings
        - Most basic kind
        - Binary safe. It can contain any kind of data. Example - A JPEG image or a serialized JSOn object.
        - Can store upto 512 Megabytes in length
        - Time Complexity - O(1)
        - DEMO 1 Commands:
            SET user:info:1001 ajith@surfline.com // NX -- Only set the key if it does not already exist, XX -- Only set the key if it already exist (for overwriting existing values)
            GET user:info:1001
            Supports polymorphism - same key can have values with different dataypes
            SET user:info:1001 10
            GET user:info:1001
            INCRBY user:info:1001 1 // (integer) 11
            If we perform a incrby operation on a key having string value Redis throws an error. This is because Redis checks the encoding of the value stored in the key and does the increment operation. We can check the encoding by:
            OBJECT ENCODING user:info:1001 // "int"
        Use case: Caching HTML fragments or pages

    Lists
        - Ordered collection of strings. Allows duplicate. 
        - Redis implements lists as a doubly linked lists.
        - <DIAGRAM TODO>
        - Use cases: Stacks and Queues (Since we can ONLY do insert/delete at left or right of a list.) 
            Activity Stream in HomePage (combination of LPUSH and LRANGE)
            Add background jobs to a queue and later pull the jobs from the queue to execute
        DEMO 2 Commands:
            LPUSH homepage:recent:activities activity_100 activity_101 activity_102 activity_103 activity_104 activity_105 activity_106 activity_107 activity_108
            LRANGE homepage:recent:activities 0 -1 // If stop is negative then count to left
            The key is removed if the list is empty.
        Time Complexity:
            Adding/Deleting an element is a constant - O(1) (constant time regardless of the number of elements). 
                Does not dependent on the size of the list. i.e The speed of adding a new element with the LPUSH command to the head of a list with ten elements is the same as adding an element to the head of list with 10 million elements.
            Accessing elements - O(N)
                is very fast near the extremes of the list but is slow if you try accessing the middle of a very big list.
        TODO: Space savings ??


    When fast access to the middle of a large collection of elements is important, then we use Sets/Sorted Sets.

    Sets
        - Unordered collection of unique strings. 
        - As the Set theroy, this data structure supports unions(SUNION), intersections(SINTER), differences(SDIFF) of sets.
        
        Time Complexity:
         Add (SADD), remove(SPOP), and test for existence of members(SISMEMBER) - O(1)
        
        - Use case - 
            - Tag Cloud (See Demo)
            - Tracking Unique visitors (Using `SADD`, `SCAN`, `EXPIRE`)

        - DEMO Commands:
            SADD news:1001:tags "forecast" "events" "promotions" "climate"
            SADD news:1002:tags "forecast" "promotions" "climate"
            SADD news:1003:tags "climate"
            We want an inverse relation as well between tags and news:
            SADD tag:news:forecast 1001 1002 1003
            SADD tag:news:events 1001
            SADD tag:news:promotions 1001 1002
            SADD tag:news:climate 1001 1002 1003
            // TODO - Show Venn Diagram
            I want to show an Ad for news articles that have forecast and promotion tags in it.
            SINTERSTORE news:promotion tag:news:forecast tag:news:promotions // Time complexity O(N * M)
            SMEMBERS news:promotion
        
        
    Sorted Sets
        - Ordered collection of unique strings.
        - Each element has a floating point score to determine the sort order. If score is same then lexical value of the element is used. 
        - The rank is the absolute position of the element within the Sorted Set. Its a zero based integer index. Sorted from smallest to greatest rank.
        - One of the advanced data type. 
            - Add(ZADD), remove(ZREM), or update(ZADD) elements in a very fast way - Time complexity - O(log(n))
            - Elements are inserted in order.
            - To get elements in order, fast existence test, fast access to elements in the middle.
            - Use case:
                ec2 instance report - to track the number of instances rolled for a service.
                -- When an instance terminates, a Lifecycle Hook sends a SNS message that triggers a Lambda function which does the following:
                ZINCRBY services:metrics:terminated:day-1 1 "favorites-api" // Here the score is incremented on every termination.
                ZINCRBY services:metrics:terminated:day-1 1 "auth-service"
                For quick demo, 
                ZINCRBY services:metrics:terminated:day-1 5 "auth-service"
                ZINCRBY services:metrics:terminated:day-1 15 "varnish-coldfusion"
                ZRANGE services:metrics:terminated:day-1 0 -1 withscores
                ZINCRBY services:metrics:terminated:day-2 3 "entitlements-service"
                ZINCRBY services:metrics:terminated:day-2 5 "varnish-coldfusion"
                ZINCRBY services:metrics:terminated:day-2 2 "spots-api"
                ZRANGE services:metrics:terminated:day-2 0 -1 withscores 

                ZUNIONSTORE services:metrics:terminated:weekly 2 services:metrics:terminated:day-2 services:metrics:terminated:day-1
                ZREVRANGE services:metrics:terminated:weekly 0 -1 withscores // Gives a weekly report of terminated instances //scores ordered from high to low.
                zrangebyscore services:metrics:terminated:weekly -inf 5 withscores

            - Other Use cases: 
                Tracking Airflow DAG Task execution times (??)
                Leaderboard, Priority Queue - By using the same concept (ZADD and ZREMRANGEBYSCORE)
            
            - TODO: Learn diff between rank and score    

    Hashes
        - A mini key value store within a Redis Key. It maps string fields to string values. Can be used for representing objects.
        - Only single level is supported. So no nested fields. 
        - A hash can store more fields with less space. Every hash can store up to 2^32 - 1 field-value pairs (more than 4 billion).
        -  Hashes allow individual fields to be manipulated. This saves CPU, Network and other resources when only a single of a subset of      fields are required.  However, you cannot expire fields within a hash, the expiration can only be set on the Key, which therefore    includes all fields.
        - Use cases : Rate limiting and storing session stores.
        - <DEMO>
            HMSET user:token:31bb9f5d8fae0da135471ea66af0929d0c3bb48d token_type "access_token" userid "56fae6ff19b74318a73a7875" clientid "5c6f00c9f0b6cbda76bc6c40"
            EXPIRE user:token:31bb9f5d8fae0da135471ea66af0929d0c3bb48d 86400 // Expire in 1 day. In seconds.
            HGETALL user:token:31bb9f5d8fae0da135471ea66af0929d0c3bb48d
            TTL user:token:31bb9f5d8fae0da135471ea66af0929d0c3bb48d
    Bit Arrays
    Streams
    HyperLogLogs

TODO: Does Redis support indexes ???

Use case: Faceted Search / Inverted Index

    <Show Image> - A faceted search is a technique that allows simple navigation of a classification using multiple filters and criteria.
    Redis has no native support for Compound or Secondary Indexes. 
    <Demo>:
        SADD region:5908c45e6a2e4300134fbe92:subregions subregion:58581a836630e24c44878fd6 subregion:58581a836630e24c4487900a
        SADD subregion:58581a836630e24c44878fd6:spots spot:5977abb3b38c2300127471ec spot:5842041f4e65fad6a7708827
        SADD spot:premiumcam:true spot:5977abb3b38c2300127471ec spot:5c6f2b831fca150001302d97
        SADD spot:premiumcam:false spot:5842041f4e65fad6a7708827
        SADD spot:surfconditions:epic spot:5c6f2b831fca150001302d97
        Get all the spots that has epic surf conditions and a premium cam:
        SINTER spot:premiumcam:true spot:surfconditions:epic // Add more conditions
        HGETALL spot:5977abb3b38c2300127471ec

    Note on Keys:
        Try to stick with a schema. For instance "object-type:id" is a good idea, as in "user:1000". Dots or dashes are often used for multi-word fields, as in "comment:1234:reply.to" or "comment:1234:reply-to".

Transactions in Redis

    Transactions are simply a serialized queue of pending commands that Redis will execute sequentially. MULTI, EXEC, DISCARD and WATCH are the foundation of transactions in Redis. 
    Redis transaction are atomic.
    ```
        MULTI - indicates the start of a transaction
        EXEC - executes the queued commands
        DISCARD - throws away queued up commands. In a Transaction, the commands are not applied until the EXEC command is executed.
        WATCH - To observe keys if they are modified. // If a different operation modifies the key.
    ```

BitFields and BitArrays
    // Learn More

Publish and Unpublish to Channels
    SUBSCRIBE will listen to a channel
    PUBLISH allows you to push a message into a channel
    UNSUBSCRIBE
    <Show Diagram>
    Pub/Sub has no relation to the key space. It was made to not interfere with it on any level, including database numbers.
    Use cases: To build a messaging system. Update SILDE
    <DEMO Commands>:
        PSUBSCRIBE surf:alerts:HB* // C1
        PSUBSCRIBE surf:alerts* // C2
        PUBLISH surf:alerts:HB-Southside "surf-conditions:FAIR" // Serialized JSON object // C3
        PUBLISH surf:alerts:SealBeach "surf-conditions:POOR" // Serialized JSON object // C3



Geospatial Commands
    - Geospatial indexing is implemented in Redis using Sorted Sets as the underlying data structure.
    - Built-in commands like GEOADD, GEODIST, GEORADIUS, and GEORADIUSBYMEMBER.
    - Use case: Build Real Time applications based on user's location. To promote offers or hotel deals within a certain radius of user location.
    - <DEMO Commands>
        GEOADD geopoints:spots -118.0062506 33.6552107 "HB Pier"
        ZRANGE geopoints:spots 0 -1 withscores
        GEOHASH geopoints:spots "HB Pier"
        Redis computes a Geohash from the Latitude and Longitude. This is a 52 bit number stored as a score in the Sorted Set
        http://geohash.co/
        GEOADD geopoints:spots -118.11569 33.755653 "Seal Beach" -117.9406065 33.6181326 "Newport Beach"
        GEOADD geopoints:spots -117.8649696 33.6841646 "my-location"
        ZRANGE geopoints:spots 0 -1 withscores
        GEODIST geopoints:spots "my-location" "Seal Beach" mi
        GEORADIUSBYMEMBER geopoints:spots "my-location" 10 mi withdist count 2 asc
        GEORADIUSBYMEMBER geopoints:spots "my-location" 100 mi withdist

    - Redis uses Haversine formula for computing distance between 2 coordinates.

Running LUA scripts
    - Wrap Redis command with Lua
    - Reduce network traffic
    - Similar to Stored Procedures
    - Treated as an Atomic unit of work

    EVAL lua_script
    
    <DEMO Commands>:
    ```
    SET company:name "Wavetrak"
    script load "local val=redis.call('GET', KEYS[1]) return val”
    evalsha "dd47ad79bb7b6d7d2b8e0607c344d134412e84e0" 1 company:name
    redis-cli --eval simple.lua lua_demo company , "Wavetrak"
    ```
    NOTE: These loaded scripts are not stored in Redis, they are just cached. If server restarts the scripts will be gone.

Demo
