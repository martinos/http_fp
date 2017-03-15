require 'http_fp'
require 'active_support'
require 'pp'
require 'rack'
#
# https://www.diffchecker.com/ihCGIKyG

module HttpFp::Rack
  mattr_reader :to_env
  @@to_env = -> request {
    session ||= {}
    session_options ||= {}

    uri = request >>+ HttpFp.to_uri 
    header = (request[:header] || {}).dup
    body = request[:body] || ''

    content_type_key, val = header.detect { |key, val| puts key; key.downcase == "content-type"}
    env = {
      # CGI variables specified by Rack
      'REQUEST_METHOD' => request[:method].to_s.upcase,
      'CONTENT_TYPE'   => header.delete(content_type_key),
      'CONTENT_LENGTH' => body.bytesize,
      'PATH_INFO'      => uri.path,
      'QUERY_STRING'   => uri.query || '',
      'SERVER_NAME'    => uri.host,
      'SERVER_PORT'    => uri.port,
      'SCRIPT_NAME'    => ""
    }

    env['HTTP_AUTHORIZATION'] = 'Basic ' + [uri.userinfo].pack('m').delete("\r\n") if uri.userinfo

    # Rack-specific variables
    env['rack.input']      = StringIO.new(body)
    env['rack.errors']     = $stderr
    env['rack.version']    = ::Rack::VERSION
    env['rack.url_scheme'] = uri.scheme
    env['rack.run_once']   = true
    env['rack.session']    = session
    env['rack.session.options'] = session_options

    header.each do |k, v|
      env["HTTP_#{k.tr('-','_').upcase}"] = v
    end
    env
  }
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
