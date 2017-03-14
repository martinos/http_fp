require 'superators19'

class Object
  superator ">>~" do |fn|
    -> a { fn.(self.(a)) }
  end

  superator ">>+" do |fn|
    fn.(self)
  end
end


