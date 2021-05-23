require_relative '../../src/boolean'
require_relative '../../src/persistible'

class Person
  include Persistible

  has_one String, named: :first_name
  has_one String, named: :last_name
  has_one Numeric, named: :age
  has_one Boolean, named: :is_admin

  attr_accessor :saraza

  def initialize
    super
    self.is_admin = false
  end

end