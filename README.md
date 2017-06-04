# HttpFp

Functional http client in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_fp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_fp

## Usage

### Basics 

#### The Request Structure

In order to query an HTTP server you will need to build a request hash.

Here is an example of a request:

```
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

To build that request you can use builder functions and the function composition operator (`>>~`). Every builder function adds values to the response object.  Example: 

```
query = verb.("get") >>~ 
        with_path.("/users/martinos/repos") >>~ 
        with_host.("https://api.github.com") >>~ 
        add_headers.(json_headers)
```
In `query` variable is a function that is created by combining builder functions together.

This query function takes a hash as a parameter, and returns a decorated hash decorated by the builders.
 
We need an initialized request (`empty_request`) to demonstrate how it works.

Here is the `empty_request`
```
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
```
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
In order to run the query, you can combine the query with a "server" function (lambda) that takes a `request` sends it to the server and returns a http "response".

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

You can also use the pipe operator (`>>+`) and the run function. Run function takes a function as parameter and applies the `empty_req` to it.


```
(query >>~ HttpFp::NetHttp.server) >>+ run
```


## Contributing

1. Fork it ( https://github.com/martinos/http_fp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
