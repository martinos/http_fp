require "superators19"

class Proc
  superator ">>~" do |fn|
    -> a { fn.(self.(a)) }
  end
end

class Object
  superator ">>+" do |fn|
    fn.(self)
  end
end
