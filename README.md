# Table of contents

- [troclapi](#troclapi)
  - [Usage](#usage)
    - [Login](#login)
      - [POST /login](#post-login)
    - [create](#create)
      - [POST /v1/key/:key/:format](#post-v1keykeyformat)
      - [POST /v1/create/](#post-v1create)
    - [get](#get)
      - [GET /v1/key/:key/:format](#get-v1keykeyformat)
      - [POST /v1/get/](#post-v1get)
    - [set](#set)
      - [PUT /v1/key/:key/:format](#put-v1keykeyformat)
      - [POST /v1/set/](#post-v1set)
    - [reset](#reset)
      - [PATCH /v1/key/:key/:format](#patch-v1keykeyformat)
      - [POST /v1/reset/](#post-v1reset)
    - [delete](#delete)
      - [DELETE /v1/key/:key/:format](#delete-v1keykeyformat)
      - [POST /v1/delete/](#post-v1delete)
    - [search](#search)
      - [CET /v1/search/:key](#cet-v1searchkey)
    - [formats](#formats)
      - [GET /v1/formats](#get-v1formats)
      - [GET /v1/formats/:format](#get-v1formatsformat)
      - [GET /v1/formats/:key/](#get-v1formatskey)
      - [GET /v1/formats/:key/:format](#get-v1formatskeyformat)
      - [POST /v1/formats/](#post-v1formats)
    - [Example](#example)
  - [Installation](#installation)
  - [Docker](#docker)
  - [Configuration](#configuration)
    - [Setting](#setting)

# troclapi

Basic api for trocla usage

## Usage

Show [Trocla documentation](https://github.com/duritong/trocla) for all usage

Please, show trocla documatation for all params

### Login

#### POST /login
Login with Ldap or admin token

With token:
```JSON
{
  "token": "LFchdkKV0wSa6yuprnxlA8UAPdMLaCXu"
}
```

If you doesn't use cookie with token authentification, you can use header X-Token. Exemple:
```BASH
curl -s -XGET 0.0.0.0:4567/v1/key/mykey0/plain  -H 'X-Token: ZOW7JrxW4S8yuJSuCWfh28uJTRQ6RPUQToDZ4l8otp2vRSl9A5gt0oQewjkZMuM9' | jq
{
  "format": "plain",
  "value": "QObjamgUMLczBhmfgc1R",
  "success": true
}
```

Ldap connection
```JSON
{
  "username": "my.user",
  "password": "mypass"
}
```

### create

#### POST /v1/key/:key/:format

Create key with specific value

json example:
```JSON
# Optional
{
  "length": 20,
  "charset": "alphanumeric"
}
```

#### POST /v1/create/

Create multiple key with specific value

json example:
```JSON
{
  "length": 20,
  "charset": "alphanumeric",
  "format": "plain", # Using by default
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

#### GET /v1/key/:key/:format

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

#### DELETE /v1/key/:key/:format

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

### search

#### CET /v1/search/:key

Search key with ruby regex format

### formats

#### GET /v1/formats

Return available trocla formats

#### GET /v1/formats/:format

Return if formats is available

#### GET /v1/formats/:key/

Return avalaible format for a specific key

#### GET /v1/formats/:key/:format

Return if format is available for this key

#### POST /v1/formats/

Return available format for multi key

json example:
```JSON
{
  "keys": [
    "mykeys0",
    "mykey1"
  ]
}
```

### Example

```JSON
# curl -s troclapi.local/login -XPOST -d '{"username": "my.user", "password": "secret"}' -c /tmp/cookie | jq
{
  "success": true
}

# curl -s -b /tmp/cookie troclapi.local/v1/key/toto/plain | jq
{
  "format": "plain",
  "value": "toto",
  "success": true
}

# curl -s -b /tmp/cookie -XPOST troclapi.local/v1/key/mysqlkey/mysql -d '' | jq
{
  "format": "mysql",
  "value": "*2B74D8F42C6EC26269106199686D2386A2E47D18",
  "success": true
}

# curl -s -b /tmp/cookie -XPOST troclapi.local/v1/key/mysqlkey/plain -d '' | jq
{
  "format": "plain",
  "value": "ze.4D8{TM)*]m0CF",
  "success": true
}

# curl -s -b /tmp/cookie -XPOST troclapi.local/v1/get/ -d '{"keys": [{"key": "toto"},{"key": "titi"},{"key": "mysqlkey", "format": "mysql"},{"key": "mysqlkey", "format": "plain"}]}' | jq
[
  {
    "format": "plain",
    "value": "toto",
    "success": true,
    "key": "toto"
  },
  {
    "error": "Key not found on this format",
    "success": false,
    "key": "titi"
  },
  {
    "format": "mysql",
    "value": "*2B74D8F42C6EC26269106199686D2386A2E47D18",
    "success": true,
    "key": "mysqlkey"
  },
  {
    "format": "plain",
    "value": "ze.4D8{TM)*]m0CF",
    "success": true,
    "key": "mysqlkey"
  }
]

```

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

Add api configuration on trocla configuration file. The troclarc file can be define with environment variable `TROCLARC_FILE`.

### Setting

```YAML
api:
  setting: # Sinatra setting
    :bind: 0.0.0.0
    :port: 5678
    :logging: Logger::INFO
  actions: # Allow trocla actions. For all remove this params
    - formats
    - get
    - search
  tokens:
    dev: LFchdkKV0wSa6yuprnxlA8UAPdMLaCXu
    ansible: TRFgkHDFgh65KJHGhf5jHJg5KJgjhvg
  ldap:
    :host: '127.0.0.1'
    :base: 'OU=People,DC=local'
    :filter: '(&(sAMAccountName={username}))' # Using {username} for the username
    :auth:
      :method: :simple
      :username: 'CN=service.user,OU=Services,DC=local'
      :password: secret
```

Show [Sinatra documentation](http://www.sinatrarb.com/configuration.html) for available settings, and [Net::LDAP](http://www.rubydoc.info/gems/ruby-net-ldap/Net/LDAP) for ldap options (default filter sAMAccountName=username)
