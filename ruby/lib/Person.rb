require_relative '../src/Boolean'
require_relative '../src/persistible'

class Person

  has_one String, named: :first_name
  has_one String, named: :last_name
  has_one Integer, named: :age
  has_one Boolean, named: :is_admin

  attr_accessor :first_name, :last_name, :age, :is_admin

  def initialize
    super
    self.is_admin = false
  end

end