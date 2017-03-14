# Partial application

add = -> (a, b) { a + b } # => #<Proc:0x007fc63088cbf8@/var/folders/3d/0bcszqq14k565g0sqxghlmcm0000gp/T/seeing_is_believing_temp_dir20170217-11466-mjkeys/program.rb:3 (lambda)>
add.(2, 3) # => 5


add = -> a { -> b {a + b} }
add2 =  add.(2) # => #<Proc:0x007fc63088c838@/var/folders/3d/0bcszqq14k565g0sqxghlmcm0000gp/T/seeing_is_believing_temp_dir20170217-11466-mjkeys/program.rb:7 (lambda)>
add2.(3)  # => 5

add =  -> (a, b) { a + b }.curry
add2 =  add.(2)

mult = -> a {-> b {a * b}} # => #<Proc:0x007fc63088c298@/var/folders/3d/0bcszqq14k565g0sqxghlmcm0000gp/T/seeing_is_believing_temp_dir20170217-11466-mjkeys/program.rb:14 (lambda)>

mult.(20).(3) # => 60

mult3 = ->a {-> b {-> c {a * b * c}}}

mult3[1][5][6] # => 30


# Function composition

require 'superators19'

class Proc
  superator ">>~" do |fn|
    -> a { fn.(self.(a)) } 
  end

  def then(fn)
    -> a { fn.(self.(a)) }
  end
end

debug = -> a { puts "debug #{a}"; a }

doing = add.(2) >>~ mult.(3)

a = add.(2).then(mult.(3)) # => #<Proc:0x007fc63217da68@/var/folders/3d/0bcszqq14k565g0sqxghlmcm0000gp/T/seeing_is_believing_temp_dir20170217-11466-mjkeys/program.rb:33 (lambda)>

doing.(2) # => 12


[1, 2, 3, 5].map(&doing)


lines = -> s { s.split("\n") }
words = -> s { s.split(" ") }
upcase = -> s { s.upcase }


class Object
  superator ">>+" do |fn|
    fn.(self)
  end
end

class String
  superator ">>+" do |fn|
    fn.(self)
  end
end

kilo = mult.(1000)
mega = kilo >>~ kilo
mega.(3)  # => 3000000
# to_s = -> a {a.to_s}
"2"  >>+ (to_s >>~ mega) # => NameError: undefined method `superator_definition_62_62__126' for class `String'

# Functors

class Maybe
  def initialize(val)
    @val = val
  end

  def map(&fn)
    if @val != nil
      Maybe.new(fn.(@val))
    else
      Maybe.new(nil)
    end
  end

  def withDefault(default)
    @val.nil? ? default : @val
  end
end 


martin = {first_name: "Martin", last_name: "Chabot"}

guest = {first_name: "Guest", last_name: ""}

user = Maybe.new(nil)


full_name = -> user {user[:first_name] + " " + user[:last_name]}

user.map(&(full_name >>~ upcase)).withDefault("Unknown") # => 

require 'json'

to_json = -> a {a.to_json}
user.map(&to_json).withDefault({error: "user not found"}.to_json) # => 

at = -> key { -> hash { Maybe.new(hash.fetch(key)) }}

phone_nums = {first_num: 5143330000, range: nil} 


[at[:first_num][phone_nums].withDefault(0), at[:first_num][phone_nums].map(& -> first_num { first_num + at[:range][phone_nums].withDefault(0) }).withDefault(0) ] 

reverse = -> a { a.reverse }
"asdf" >>+ (upcase >>~ debug >>~ reverse)

user = {first_name: "Martin", last_name: "Chabot"} 

user >>+ at[:first_name]

# ~> NameError
# ~> undefined method `superator_definition_62_62__126' for class `String'
# ~>
# ~> /Users/mchabot/.gem/ruby/2.1.3/gems/superators19-0.9.3/lib/superators19/macro.rb:12:in `method'
# ~> /Users/mchabot/.gem/ruby/2.1.3/gems/superators19-0.9.3/lib/superators19/macro.rb:12:in `superator_send'
# ~> /Users/mchabot/.gem/ruby/2.1.3/gems/superators19-0.9.3/lib/superators19/macro.rb:65:in `block (2 levels) in superator'
# ~> /var/folders/3d/0bcszqq14k565g0sqxghlmcm0000gp/T/seeing_is_believing_temp_dir20170217-11466-mjkeys/program.rb:65:in `<main>'

