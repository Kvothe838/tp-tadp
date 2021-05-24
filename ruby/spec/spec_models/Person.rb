require_relative '../../src/boolean'
require_relative './Student'
require_relative '../../src/persistible'
require 'tadb'                    #Usado para el debugger

class Person
  include Persistible

  has_one String, named: :first_name, no_blank: true, from: 18, to: 100, validate: proc{value>2}
  has_one String, named: :last_name
  has_one Numeric, named: :age
  has_one Boolean, named: :is_admin
  has_one Grade, named: :grade

  attr_accessor :saraza

  def initialize
    super
    self.is_admin = false
  end

end