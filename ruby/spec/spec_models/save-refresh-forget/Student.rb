require_relative '../../../src/persistible'

class Student
  include Persistible

  has_one String, named: :full_name
  has_one Grade, named: :grade
end
