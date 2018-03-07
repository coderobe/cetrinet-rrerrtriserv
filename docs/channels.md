# Channels

_Not to be confused with Redis PubSub channels, those are handled in
`redis-pubsub.md`._

## Redis implementation

All available channels are defined in the set key `channels`.

Channel metadata (e.g. configuration) is stored in the hash key
`channel:#channelname`

A listing of users is stored in the sorted set key `channel:#channelname:users`

### Creating (Adding) a new channel

To create a new channel `#channelname`:

```redis
SADD channels #channelname
```

### Channel listing

Since the channels are stored in a set, just iterate over them with a cursor:

```redis
SSCAN channels 0
SSCAN channels 1
...
SSCAN channels N
```

Don't want to iterate and get **ALL** of the channels instead?  I've got you
covered:

```redis
SMEMBERS channels
```

### User join

```redis
ZADD channel:#channelname:users 0 username#tripcode
```

### User part

```redis
ZREM channel:#channelname:users username#tripcode
```

### User count

```redis
ZCOUNT channel:#channelname:users -inf +inf
```

### Users in a channel

```redis
ZRANGE channel:#channelname:users 0 -1
```
