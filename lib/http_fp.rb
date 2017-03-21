require "active_support"
require "http_fp/version"
require 'http_fp/utils'
require 'uri'

module HttpFp
  include Utils
  mattr_accessor :verb, :with_host, :with_path, :with_query, :withUri, :with_json, :with_headers, :add_headers,  :fetch, :to_curl, :out_curl, :json_resp, :to_uri, :empty_req, :run, :json_headers

  @@empty_req = {proto: "HTTP/1.1", host: "http://example.com", path: "/", query: {}, header: {}, method: "GET", body: ""}
  @@empty_resp = {status: nil, header: {}, body: {}}

  @@run = -> fn { fn.(@@empty_req) }
  @@verb = -> verb, req { req.merge({method: verb.to_s.upcase}) }.curry
  @@with_host = -> host, req { req[:host] = host; req }.curry
  @@with_path = -> path, req { req[:path] = path; req }.curry
  @@with_query = -> params, req { req[:query] = params ; req }.curry
  @@with_json = -> hash, req { req[:body] = hash.to_json; req }.curry
  @@with_headers = -> header, req { req[:header] = header ; req }.curry
  @@add_headers = -> header, req { req[:header].merge!(header); req }.curry

  @@json_resp = Utils.at.(:body) >>~ Utils.parse_json
  @@print = -> a { $stdout.puts a.pretty_inspect ; a }
  @@to_uri = -> req {
    uri = URI(req.fetch(:host))
    req[:query] && uri.query = URI.encode_www_form(req[:query])
    uri.path = req[:path]
    uri}
  @@json_headers = 
    {"accept"     => "application/json",
     'Content-Type' => 'application/json',
     "user-agent" => "paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest"}
end
