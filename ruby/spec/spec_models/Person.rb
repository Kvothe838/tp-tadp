require_relative '../../src/boolean'
require_relative './Student'
require_relative '../../src/persistible'
require 'tadb'                    #Usado para el debugger

class Person
  include Persistible

  has_one String, named: :first_name, no_blank: true
  has_one String, named: :last_name, default: "Test"
  has_one Numeric, named: :age, from: 18, to: 100
  has_one Boolean, named: :is_admin
  has_one Grade, named: :grade, default: Grade.new, validate: proc { value > 2 }
  has_many Numeric, named: :notes
  has_many String, named: :apodos
  has_many Grade, named: :grados

  def initialize
    super
    self.is_admin = false
  end

end