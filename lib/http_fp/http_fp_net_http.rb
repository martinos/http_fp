require 'net/http'
require 'http_fp'

module HttpFp::NetHttp
  include HttpFp
  mattr_accessor :method_str_to_req, :_send, :net_resp

  @@method_str_to_req = {"GET" => Net::HTTP::Get, "POST" => Net::HTTP::Post, "DELETE" => Net::HTTP::Delete, "PUT" => Net::HTTP::Put}

  @@_send = -> req { 
    uri = to_uri.(req) 
    req_ = method_str_to_req[req[:method]].new(uri)
    req_.set_body_internal(req[:body]) if req[:body]
    header = req[:header]
    header.each { |key, val| req_[key] = val}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    # http.set_debug_output($stdout)
    @@net_resp.(http.request(req_))
  } 

  @@net_resp = -> resp { {status: resp.code, header: resp.to_hash, body: resp.body} }
end