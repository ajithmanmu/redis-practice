### Modules
Redis is built in C. 

Redis Module can be added by:
1. Through the redis.conf file
2. As a command line argument
3. Using MODULE LOAD command
4. Through Redis Enterprise GUI.

Redis uses a shared object file binary to load modules into the server.

Modules vs Lua : 
![Lists](./modulesvslua.png?raw=true "Lists")

Any number of fields can be stored in any document, but only the fields that will be queryable need to be in the index schema.

Tokenization - Splitting the text into logical sets called tokens. Ignore spaces or any other special characters.
RedisSearch has a set of default stop words. The engine will ignore those words because they don't add any value. Example "a", "is" etc.

Stemming - is an internal operation  where the search engine queries for the root or stem of a word to more broadly match the idea of the literal characters that make up a specific word. Stemming is very language specific.

RediSearch can be used as a Secondary Index. A secondary index can unify multiple data stores Secondary indexes can knit together multiple sources of data under one index. Optimizing infrastructure spend for throughput rather than storage.
You can spend your infrastructure budget to deliver results quickly without having to have large outlay for storage.
Flexibility of having the documents stored in separately from the indexes. By decoupling the index from the stored documents, it's possible to be more flexible in responding to changes.


When you add a document to an index in RediSearch you're actually creating multiple keys.
Indexes do not reside at a singular key, therefore UNLINK and DEL have no affect on them.

Only Redis Enterprise can cluster RediSearch. Redis Cluster is incompatible for RediSearch.
RediSearch is designed to be one index per database.

![Lists](./comparison.png?raw=true "Lists")

RediSearch is compiled to a shared object file and loaded through the foreign function interface
Since both Redis and RediSearch are compiled software, they must use a specialized interface to interoperate as they lack any form of runtime.

RediSearch has four valid types: Text, Numeric, Tag and Geo.

