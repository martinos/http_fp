# HttpFn

Functional http client in Ruby.

## Usage

### Basics 

#### The Request Structure

In order to query an HTTP server you will need to build a request hash.

Here's an example of a request:

```ruby
{:proto=>"HTTP/1.1",
 :host=>"http://api.github.com",
 :path=>"/users/martinos/repos",
 :query=>{},
 :header=>
  {"accept"=>"application/json",
   "Content-Type"=>"application/json",
   "user-agent"=>"paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest"},
 :method=>"GET",
 :body=>""}
```

To build that request you can use builder functions and the function composition operator ([`>>`](https://docs.ruby-lang.org/en/2.6.0/Proc.html#method-i-3E-3E)). Every builder function adds values to the response object.  Example: 

```ruby
query = verb.("get") >>
        with_path.("/users/martinos/repos") >>
        with_host.("https://api.github.com") >>
        add_headers.(json_headers)
```
The `query` variable is a builder function that is created by combining multiple builder functions together.

This `query` function takes a hash as a parameter, and returns a hash decorated by the builders.
 
To demonstrate how it works, we need an initialized request (`empty_req`). Here's the `empty_req`:

```ruby
pp empty_req
# => 
{:proto=>"HTTP/1.1",
 :host=>"http://example.com",
 :path=>"/",
 :query=>{},
 :header=>{},
 :method=>"GET",
 :body=>""}
```

We apply the `empty_req` to the query that we've built.
```ruby
pp query.(empty_req)
# => 
{:proto=>"HTTP/1.1",
 :host=>"https://api.github.com",
 :path=>"/users/martinos/repos",
 :query=>{},
 :header=>
  {"accept"=>"application/json",
   "Content-Type"=>"application/json",
   "user-agent"=>"paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest"},
 :method=>"GET",
 :body=>""}
```
In order to `run` the query, you can combine the query with a "server" function (lambda) that takes a "request", sends it to the server and returns a http "response".

```ruby
HttpFn::NetHttp.server.(query.(empty_req))

# => 
{:status=>"200",
 :header=>
  {"server"=>["GitHub.com"],
   "date"=>["Sun, 04 Jun 2017 02:20:05 GMT"],
   "content-type"=>["application/json; charset=utf-8"],
   "vary"=>["Accept", "Accept-Encoding"], 
    ...},
  }
 :body => "{...}"
}

```

```ruby
(query >> HttpFn::NetHttp.server).(empty_req)
```

Since a "server" is just a function that takes an HTTP request and returns an HTTP response, instead of using Net::Http interface you can use the `HttpFn::Rack.server` function that takes a rack app as parameter.

```run
query >> HttpFn::Rack.server.(Rails.application)
```

## Middlewares

Since we are using composable functions to build our request and to query the web server, it's very easy to create our own "middlewares".

If we want to all the request and the response we can create a simple function such as:

```
debug_fn = -> print, fn, input {
  print.("Input: \n")
  print.(input.to_s)
  output = fn.(input)
  print.("Output: \n")
  print.(output)
  output
}.curry

```

the `print` param is a function that prints an object.

```
printer = -> a { print a; a } 
query >> debug_fn.(printer).(HttpFn::NetHttp.server)
```

of course you can change the printer to print to the log file.

```
printer = -> a { logger.debug(a) ; a }
```

### Curl, Httpie output

If you want to generate documentation with curl commands you can use a simple function such as:

```
curl = -> a { puts HttpFn::Curl.req.(a) ; a }.curry
```

Then you can use it with the query and the server function.

```run
query >> curl >> HttpFn::NetHttp.server
```

This will output:

```
curl -X 'GET' 'https://api.github.com/users/martinos/repos?' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -H 'user-agent: ruby net/http'
```



## Contributing

1. Fork it ( https://github.com/martinos/http_fn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
