#Messages Microservice

This code challenge had some vague requirements, part of the work for it was making decisions about the unspecified or undefined points in the original requirements.

A REST server was requested with two endpoints:

* `POST` endpoint receiving a string as its input and returning a string saying "[input string] from [country where the request came from]"
* `GET` endpoint to list messages allowing to filter by language and to limit the total amount of results returned

This solution was thought as a micro service that could be part of a bigger distributed system as well as used by a simple fronted application. For this purpose, it uses a JSON interface which helps it define a clear interface to interact with other components.

Given this should be a micro service and probably run on its own address, it uses the root endpoint with the `GET` and `POST` HTTP verbs variants instead of defining any named endpoints.

## Setup

You need a working Ruby 2.x environment. It's been tested in Ruby 2.3.1, but it should work in 2.2.x as well.

Messgaes are stored in a SQLite3 database, no need for a database server.

### Dependencies

It requires the following gems for runtime:

* cuba -v 3.8.0
* sequel -v 4.39.0
* sqlite3 -v 1.3.11
* rack-parser -v 0.7.0
* oj -v 2.17.4
* scrivener -v 1.0.0

And these for running the test suite:

* rack-test -v 0.6.3
* mocha -v 1.1.0


Gems dependencies are listed in `.gems` and `.gems-test` files to be used with the [dep](https://rubygems.org/gems/dep) gem.

If you want to use `dep`, first [get the code](#clone-the-repository), then run the following within the cloned directory:

```
gem install dep
dep install && dep -f .gems-test install
```

Or you can manually install them:

```
cat {.gems,.gems-test} | sed -e 's/ -v /:/g' | xargs -p gem install
```

It's highly recommendable to use gemsets for environment isolation.


## Running the code

### Clone the repository

```
git clone https://github.com/kandalf/messages-microservice && cd messages-microservice
```

### Start the app server

```
rackup -p 9292
```

After this point you can start making requests to `http://localhost:9292` using `curl` or any other HTTP client.


## API Documentation


### Create message

`POST /`

Create a new message.

This endpoints accepts the following parameters:

* message: The actual message string. **Mandatory**
* lang:    A locale like string specifying the language of the message. For example: `es-AR`, `en-US`, `en-UK`, `nl-NL` **Optional**

If `lang` is not specified, it will be guessed from the country where the request comes from.

### Request

```
Content-type: application/json

{
  message: "Hello",
  lang: "en-US"
}
```

### Responses

####Success

```
201 Created

Content-type: application/json

{ "message": "Hello from Argentina" }
```

#### Bad Request

Not a JSON request

```
400 Bad Request

Content-type: application/json

{ "message": "Bad Request" }
```

#### Unprocessable Entity

Message is empty or missing

```
422 Unprocessable Entity

{
  "message": "Unprocessable Entity",
  "errors": { "body": ["not_present"] }
}
```


## List messages

`GET /`

List messages ordered by creation date with newer messages first.

It accepts two query parameters:

* lang: Locale-like string (`es-AR`, `en-US`, `es`) to filter messages by language. The special non-locale-like string "all" is accepted. **Optional**
* limit: Integer to limit the amount of results to return. **Optional**

### Request

```
GET /?lang=es&limit=3
```

### Responses

#### Success

```
200 OK

Content-type: application/json

{
  "messages":
  [
    {
      "id": 34,
      "body": "randomly",
      "origin": null,
      "language": "es-AR",
      "country": "UnitedStates",
      "created_at": "2016-10-10T13:14:34-03:00",
      "updated_at": "2016-10-10T13:14:34-03:00"
    },
    {
      "id": 33,
      "body": "randomly",
      "origin": null,
      "language": "es-AR",
      "country": "UnitedStates",
      "created_at": "2016-10-10T13:14:34-03:00",
      "updated_at": "2016-10-10T13:14:34-03:00"
    },
    {
      "id": 32,
      "body": "messages",
      "origin": null,
      "language": "en-US",
      "country": "Netherlands",
      "created_at": "2016-10-10T13:14:34-03:00",
      "updated_at": "2016-10-10T13:14:34-03:00"
    }
  ]
}

```

#### Bad Request

Limit is not numeric

```
400 Bad Request

Content-type: application/json

{ "message": "Limit must be a number" }
```
