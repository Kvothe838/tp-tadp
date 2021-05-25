
require_relative './Grade.rb'
require_relative '../../src/persistible'

class OtherPerson
  include Persistible
  has_one String, named: :full_name
end


class Student < OtherPerson
  has_one Grade, named: :grade
end