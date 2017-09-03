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

Ldap connection
```JSON
{
  "login": "my.user",
  "password": "mypass"
}
```

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

### search

#### POST /v1/search/

Search key with ruby regex format

json example:
```JSON
{
  "keys": [
    "*toto",
    "titi"
  ]
}
```

### formats

#### GET /v1/formats

Return available trocla formats

#### GET /v1/formats/:format

Return if formats is available

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

Add api configuration on trocla configuration file.

### Setting

```YAML
api:
  setting: # Sinatra setting
    :bind: 0.0.0.0
    :port: 5678
    :logging: Logger::INFO
  actions: # Allow trocla actions. For all remove this params
    - format
    - get
    - search
  token: LFchdkKV0wSa6yuprnxlA8UAPdMLaCXu
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
