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

[pubsub]: https://redis.io/topics/pubsub
