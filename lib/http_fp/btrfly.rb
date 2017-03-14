require './utils'
require 'pp'
require './http_fp'
require './http_fp_net_http'

include Utils

include HttpFp
include HttpFp::NetHttp

print = -> a { $stdout.puts a.pretty_inspect ; a }

json_headers = 
  {"accept"     => "application/json",
   'Content-Type' => 'application/json',
   "user-agent" => "paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest"}

get_airport_newsfeed = -> airport { verb.("get") >>+ with_path.("/api/airports/#{airport}/newsfeed") }

# Airports checkin
airport_checkins_path = -> airport { with_path.("/api/airports/#{airport}/checkins") }
get_airport_checkins = -> id { verb.("get") >>+ airport_checkins_path.(id) }

# Topic Messages
topic_path = -> id { with_path.("/api/topic_messages/#{id}") }
get_topic_message = -> id { verb.("get") >>+ topic_path.(id) }

# Newsfeed Threads
newfeed_threads_path = -> id { with_path.("/api/newsfeed_threads/#{id}") }
get_newsfeed_threads = -> id { verb.("get") >>+ newfeed_threads_path.(id) }

# Users
users_path = -> id { with_path.("/api/users/#{id}") }
get_user = -> id { verb.("get") >>+ users_path.(id) }.curry

# UserCoupons
user_coupons_path = -> user_id { with_path.("/api/users/#{user_id}/coupons") }
get_user_coupons = -> user_id { verb.("get") >>+ user_coupons_path.(user_id) }.curry

# Authentication
sign_in = -> email, password {
  verb.("post") >>+ (with_path.("/users/sign_in") >>~ with_json.({user: {email: email, password: password}}))
}.curry

sign_out = verb.("delete") >>+ with_path.("/users/sign_out")

auth_headers_from_user = -> resp { 
  {"X-API-EMAIL" => resp["user"]["email"],
   "X-API-TOKEN" => resp["user"]["authentication_token"] }}

default_cache = cache.(expired.(30)).("coucou.txt")
fetch = out_curl >>~ (default_cache.(HttpFp::NetHttp._send)) >>~ resp_to_json

credentials = -> env, email, pwd { sign_in.(email).(pwd) >>+ (env >>~ fetch >>~ auth_headers_from_user )}.curry

staging = 
   with_host.("https://btrfly-lounge-staging.herokuapp.com")

dev =
   with_host.("http://localhost:3000")

env = add_headers.(json_headers) >>~ staging

user_auth = credentials.(env).("chabotm@gmail.com").("tata1234")

auth_fetch = env >>~ add_headers.(user_auth) >>~ out_curl >>~ fetch


# pp get_topic_message.(221) >>+ auth_fetch
# pp get_airport_newsfeed.("SFO") >>+ auth_fetch
# pp get_newsfeed_threads.(1) >>+ auth_fetch
# pp get_user.(10) >>+ auth_fetch
# pp update_bank_code.("mart_code_1") >>+ auth_fetch
get_airport_checkins.("YUL") >>+ auth_fetch

martin_id = 570 # puts (user_auth >>~ users.(martin_id) >>~ fetch).({})
# pp get_user_coupons.(martin_id) >>+ auth_fetch


update_bank_code = -> code { 
 verb.("put") >>+ ( users_path.(martin_id) >>~ 
                    with_json.(user: {bank_code: code, birthday: "1971-01-28"}))}

