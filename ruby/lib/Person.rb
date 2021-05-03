require 'tadb'
require_relative '../src/persistible'
class Person

  include Persistible
  has_one String, named: :first_name
  has_one String, named: :last_name
  has_one Numeric, named: :age

  attr_accessor :first_name, :last_name, :age

end