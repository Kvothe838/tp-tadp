
require_relative './Grade.rb'
require_relative '../../src/persistible'

class Student
  include Persistible
  has_one String, named: :full_name
  has_one Grade, named: :grade

  attr_accessor :full_name, :grade
end