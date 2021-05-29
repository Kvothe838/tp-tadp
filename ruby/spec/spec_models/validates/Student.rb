require_relative '../../../src/persistible'

class Student
  include Persistible

  has_one String, named: :full_name, no_blank: true
  has_one Numeric, named: :dni, default: 11111
  has_one Numeric, named: :age, from: 18, to: 100
  has_one Grade, named: :grade
  has_many Grade, named: :grades, validate: proc{ value > 2 }
end
