### Transactions in Redis
Transactions are simply a serialized queue of pending commands that Redis will execute sequentially. 

```
MULTI - indicates the start of a transaction
EXEC - executes the queued commands
DISCARD - throws away queued up commands. In a Transaction, the commands are not applied until the EXEC command is executed, so there are no commands to undo.
WATCH - To observe keys if they are modified.
```

Redis does not support nested transactions.

In a queued set of commands, changes made in that Transaction are visible to the subsequent commands.

#### Q - When does an EXEC command fail ?
```
A: When an attempt is made to queue a command with a syntax error, then the Transaction is automatically marked as invalid. If EXEC is called, then the Transaction will be discarded.
If the Transaction is dependent on a watched key(s), and that key changes, then the Transaction is also automatically discarded when EXEC is called.
If a queued command operates on the wrong datatype, for example executing an INCR on a List datatype, then Redis skips this command but continues to execute the subsequent commands in the queue. So in this circumstance, it does not cause the Transaction to fail.
```

#### Hashes

Hashes allow individual fields to be manipulated. This saves CPU, Network and other resources when only a single of a subset of fields are required.  However, you cannot expire fields within a hash, the expiration can only be set on the Key, which therefore includes all fields.
```
HSET,HMGET,HGETALL,HSCAN,HDEL,HEXISTS
HGET - Time complexity is O(1)
```

```
Hashes and Sets can be used together for storing relational schemas.
Example:
Hash - hash_master_table
Hash - hash_child_table
SET hash_master_table(KEY) hash_child_table(VALUE)
```



