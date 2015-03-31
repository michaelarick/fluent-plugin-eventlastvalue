fluent-plugin-eventlastvalue
==========================

This plugin is designed to find the last value in a specified key and pass it through as lastvalue as a re-emit. As it's a buffered plugin it will write or re-emit at a (tunable) sane pace.

##Example

Given a set of input like

```
important.thing.12086 { 'time': 1413544800, 'count': 5, 'id': 12345 }
important.thing.1337 { 'time': 1413544890, 'count': 28, 'id': 1337 }
important.thing.12086 { 'time': 1413544830, 'count': 24, 'id': 33864 }
important.thing.12086 { 'time': 1413544860, 'count': 25, 'id': 12345, url: 'http://example.com/promote?someParam=something' }
important.thing.12086 { 'time': 1413544890, 'count': 18, 'id': 40555 }
important.thing.12086 { 'time': 1413544860, 'count': 6, 'id': 12345 }
```

With a conf like

```
<match important.thing.*>
    type eventlastvalue
    emit_to output.lastvalue
    id_key id
    last_value_key count
    flush_interval 1m
</match>
```

You would get

```
output.lastvalue { 'id': 12345, 'count': 6 }
output.lastvalue { 'id': 1337, 'count': 28 }
output.lastvalue { 'id': 33864, 'count': 24 }
output.lastvalue { 'id': 40555, 'count': 18 }
```

##Installation

OSX

    /opt/td-agent/embedded/bin/gem install fluent-plugin-eventlastvalue

or

    fluent-gem install fluent-plugin-eventlastvalue


##Configuration

###Parameters

#### Basic

- **id_key** (**required**)
    - The key within the record that identifies a group of events to select from.

- **last_value_key** (**required**)
    - the key from whose values we want to record the last

- **emit_to** (optional) - *string*
    - Tag to re-emit with
        - *default: debug.events*


#### Other

- **flush_interval** (optional)
    - Provided from **Fluent::BufferedOutput** time in seconds between flushes
        - *default: 60*
