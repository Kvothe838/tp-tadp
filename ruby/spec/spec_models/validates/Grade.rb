require_relative '../../../src/persistible'

class Grade
  include Persistible

  has_one Numeric, named: :value, validate: proc{ value > 2 }
end