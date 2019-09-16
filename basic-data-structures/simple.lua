if redis.call("HEXISTS",KEYS[1],KEYS[2]) == 0 then
    return redis.call("HSET",KEYS[1],KEYS[2],ARGV[1])
else
    return nil
end
