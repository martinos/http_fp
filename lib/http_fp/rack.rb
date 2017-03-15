require 'http_fp'
require 'active_support'
require 'pp'

module HttpFp::Rack
  mattr_reader :to_env
  @@to_env = -> req { 
    uri = req >>+ HttpFp.to_uri 
    res = {}
    res["REQUEST_PATH"] = req[:path]
    res["SERVER_PROTOCOL"] = req[:proto]
    res["HTTP_VERSION"] = req[:proto]
    res["rack.url_scheme"] = uri.scheme 
    res["REQUEST_METHOD"] = req[:method] 
    res["PATH_INFO"] = uri.path 

    res["HTTP_HOST"] = "#{uri.host}:#{uri.port}" 
    res["SERVER_NAME"] = "#{uri.host}" 
    res["SERVER_PORT"] = "#{uri.port}" 
    res["QUERY_STRING"] = "#{uri.query}" 
    # Needed for rack 
    res["rack.version"] = ["2.2"]
    res["rack.input"] = StringIO.new(String.new.force_encoding(Encoding::ASCII_8BIT)) 
    res["rack.errors"] = StringIO.new
    res["rack.multithread"] = false
    res["rack.multiprocess"] = false
    res["rack.run_once"] = true

    res.merge!(req[:header] >>+ @@headers_to_env)
    content_type = res.delete("HTTP_CONTENT_TYPE")
    res["CONTENT_TYPE"] = content_type if content_type
    content_length = res.delete("HTTP_CONTENT_LENGTH")
    res["CONTENT_LENGTH"] = content_length if content_length
    res
  }

  @@headers_to_env = -> headers { Hash[ headers.map { |header| @@header_to_env.(header) } ] }
  @@header_to_env = -> header { ["HTTP_" + header[0].upcase.gsub(/-/i, "_"), header[1]] }
end

# LINT STUFF

# default_env = {"REQUEST_METHOD" => "GET",
#                "SERVER_NAME" => "DUMMY",
#                "SERVER_PORT" => "9292",
#                "QUERY_STRING" => "",
#                "rack.version" => ["2.2"],
#                "rack.input" => StringIO.new(String.new.force_encoding(Encoding::ASCII_8BIT)) ,
#                "rack.errors" => StringIO.new,
#                "rack.multithread" => false,
#                "rack.multiprocess" => false,
#                "rack.run_once" => true,
#                "rack.url_scheme" => "http",
#                "PATH_INFO" => "/"}
