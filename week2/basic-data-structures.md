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

`SINTER` - Returns the members of the set resulting from the intersection of all the given sets. Cost of SINTER is governed by the cardinality(number of elements) of the smaller set.
Time Complexity of SINTER is = `O([cardinality of smaller set] X [number of total sets])`

There are two limiting factors for faceted searches using Sets. Firstly is the data distribution of matching attribute values. The second is the number of attributes being matches. This pattern relies on SINTER, which has a time complexity of O(N * M), when N is cardinality of the smallest Set and M is the number of Sets. So as the Cardinality of smallest set increases or the number of attribute being matched (i.e. the number of Sets be be examined) increases, then the cost of this method increases.

`To support Compound Indexes I think we can use Hashed Sets.`

#### Big O Notation and Redis Commands

`O(1)` --> This means the time complexity of this command is constant and it's not a function of the data cardinality. Examples of O(1) commands are APPEND, EXISTS, GET, SET, HGET LPUSH
RPOP etc. However the wall clock execution time for the same command for different size of data would be different because of CPU and network usage.

Time complexity defines the outside influences on a command. For example, the size of the structure being navigated. However, wall clock execution time is dependant on other factors, such as the amount of the data that needs to be transported, the cost of execution of the command, other pending commands etc.
Redis executes all commands in a single threaded model to ensure their atomicity.


#### Time complexity calculation Question

Three attributes have the described value distribution:

```
Attribute	Cardinality	Values and Data Distribution
A	        20,000	         True 20%, False 80%
B	        10,000	         Male 45%, Female 45%, N/A 10%
C	        15,000	         A 20%, B 20%, C 20%, D 20%, E 20%
```

The time complexity for SINTER is defined as `O(N * M)`.

If a Set is created for each Attribute and Value combination, what is Time Complexity for `SINTER` for `A= False, B=Female, C=E?`

Answer: N=3000 M=3

Explanation:
```
Set A:False = 16,000 elements

Set B:Female = 4,500 elements

Set C:E= 3,000 elements
```

SINTER = O(N * M)


`N = 3000 < 4500 < 16000`

`M = 3`




