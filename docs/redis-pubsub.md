# Redis Publish/Subscribe

This server makes use of Redis' [publish/subscribe][pubsub] functionality.

## Channels

The following rules apply:

- each channel starts with `rrerrtriserv.` to have a single scope for
  rrerrtriserv (this will be omitted in the following examples)
- the topic consists of `type.whatever`, so putting it all together it looks
  like `rrerrtriserv.type.whatever`
- the published message content is MessagePacked
  
### `cmsg.*`

the part after the type is the target (e.g. `#lobby`, `nilsding`)

Content e.g:

```ruby
{
  :source  => "nilsding",
  :message => "Hello, World!"
}
```

### `internal.*`

internal-use channels.  most of them are hacks (okay, all of them since there's
only one right now)

#### `internal.punsub.${peer}`

special channel to unsubscribe from the redis subscription.

`${peer}` is e.g. `127.0.0.1:65892`, i.e. the remote host

Content is discarded.

[pubsub]: https://redis.io/topics/pubsub
