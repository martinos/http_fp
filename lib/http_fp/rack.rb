require "http_fp"
require "pp"
#
# https://www.diffchecker.com/ihCGIKyG

module HttpFp::Rack
  fn_reader :to_env, :server, :rack_resp_to_resp

  @@server = -> rack { to_env >> rack.method(:call) >> rack_resp_to_resp }
  @@to_env = -> request {
    session ||= {}
    session_options ||= {}

    uri = request.then(&HttpFp.to_uri)
    header = (request[:header] || {}).dup
    body = request[:body] || ""

    content_type_key, val = header.detect { |key, val| puts key; key.downcase == "content-type" }
    env = {
      # CGI variables specified by Rack
      "REQUEST_METHOD" => request[:method].to_s.upcase,
      "CONTENT_TYPE" => header.delete(content_type_key),
      "CONTENT_LENGTH" => body.bytesize,
      "PATH_INFO" => uri.path,
      "QUERY_STRING" => uri.query || "",
      "SERVER_NAME" => uri.host,
      "SERVER_PORT" => uri.port,
      "SCRIPT_NAME" => "",
    }

    env["HTTP_AUTHORIZATION"] = "Basic " + [uri.userinfo].pack("m").delete("\r\n") if uri.userinfo

    # Rack-specific variables
    env["rack.input"] = StringIO.new(body)
    env["rack.errors"] = $stderr
    env["rack.version"] = ::Rack::VERSION
    env["rack.url_scheme"] = uri.scheme
    env["rack.run_once"] = true
    env["rack.session"] = session
    env["rack.session.options"] = session_options

    header.each { |k, v| env["HTTP_#{k.tr("-", "_").upcase}"] = v }
    env
  }

  @@rack_resp_to_resp = -> resp {
    { status: resp[0],
     header: resp[1],
     body: @@body_from_rack_response.(resp[2]) }
  }

  @@body_from_rack_response = -> response {
    body = ""
    response.each { |line| body << line }
    response.close if response.respond_to?(:close)
    body
  }
end
