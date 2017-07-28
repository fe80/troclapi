# troclapi

Rest api for trocla usage

WIP

## Usage

Show [Trocla documentation](https://github.com/duritong/trocla) for all usage

### create

#### POST /v1/:key/:format

Create key with specific value

json example:
```JSON
# Optional
{
  "length": 20,
  "charset": "alphanumeric"
}
```

#### PUT /v1/create/

Create multiple key with specific value

json example:
```JSON
{
  "length": 20,
  "charset": "alphanumeric",
  "format": "plain" # Using by default
  "keys": [
    {
      "key": "mykey0",
      "length": "20",
      "format": "mysql"
    },
    {
      "key": "mykey1"
    }
  ]
}
```

### get

#### GET /v1/:key/:format

Get key value

Using render format in url for select format (example: /v1/my\_x509\_key/x509/keyonly)

#### POST /v1/get/

Get multiple key

json example:
```JSON
{
  "format": "plain",
  "keys": [
    {
      "key": "mykey0"
    },
    {
      "key": "mykey1",
      "format": "x509",
      "render": "certonly"
    }
  ]
}
```

### set

#### PUT /v1/key/:key/:format

Set key

json example:
```JSON
{
  "value": "myvalue"
}
```

#### POST /v1/set/

Set multiple key

json example:
```JSON
{
  "format": "plain", # Default value
  "keys": [
    {
      "key": "mykey0",
      "value": "myvalue0",
      "format": "mysql"
    },
    {
      "key": "mykey1",
      "value": "myvalue1",
    }
  ]
}
```

### reset

#### PATCH /v1/key/:key/:format

Reset key

json example:
```JSON
# Optional
{
  "length": 20,
  "charset": "alphanumeric"
}
```

#### POST /v1/reset/

Reset multiple key

json example:
```JSON
{
  "format": "plain", # Default value
  "length": 20,
  "keys": [
    {
      "key": "mykey0",
      "length": 32,
      "format": "mysql"
    },
    {
      "key": "mykey1",
    }
  ]
}
```

### delete

#### DELETE /v1/:key/:format

Delete key

#### POST /v1/delete/

Delete mutiple key

json example:
```JSON
{
  "format": "plain", # Default value
  "keys": [
    {
      "key": "mykey0",
      "format": "mysql"
    },
    {
      "key": "mykey1",
    }
  ]
}
```

### formats

#### GET /v1/formats

Return available trocla formats

#### GET /v1/formats/:format

Return if formats is available

## Installation

* gem install bundle
* bundle install

## Docker

Available Dockerfile example on docker\_example repository

```BASH
docker build -t troclapi .
docker run -d -p 5678:5678 -v /var/log/troclapi:/var/log/troclapi troclapi
```

## Configuration

Add api configuration on trocla configuration file. Enable with

```YAML
api:
  enable: true
```

### Setting

```YAML
api:
  enable: true # enable Api
  setting: # Sinatra setting
    :bind: 0.0.0.0
    :port: 5678
  log_level: INFO
  log: /var/log/troclapi/troclapi.log # Absolute or relative path
  actions: # liste available actions, for all remove this param
    - get
    - format
    - search
```

Show [Sinatra documentation](http://www.sinatrarb.com/configuration.html) for available params, and [Logger](https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html) for available log level
