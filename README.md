# HttpFp

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

To build that request you can use builder functions and the function composition operator (`[>>~](https://github.com/martinos/http_fp/blob/master/lib/http_fp/operators.rb#L4)`). Every builder function adds values to the response object.  Example: 

```ruby
query = verb.("get") >>~ 
        with_path.("/users/martinos/repos") >>~ 
        with_host.("https://api.github.com") >>~ 
        add_headers.(json_headers)
```
The `query` variable is a builder function that is created by combining multiple builder functions together.

This `query` function takes a hash as a parameter, and returns a hash decorated by the builders.
 
To demonstrate how it works. We need an initialized request (`empty_request`). Here's the `empty_request`:

```ruby
pp empty_request
# => 
{:proto=>"HTTP/1.1",
 :host=>"http://example.com",
 :path=>"/",
 :query=>{},
 :header=>{},
 :method=>"GET",
 :body=>""}
```

We apply the empty_request to the query that we've built.
```ruby
pp query.(empty_request)
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
HttpFp::NetHttp.server.(query.(empty_req))

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

You can also use the pipe operator (`>>+`) and the run function. The `run_` function takes a function as parameter and applies the `empty_req` to it.

Here is it's definition:
```ruby
run_ = -> fn { fn.(empty_req) }
```

```run
query >>~ HttpFp::NetHttp.server >>+ run_
```


## Contributing

1. Fork it ( https://github.com/martinos/http_fp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
