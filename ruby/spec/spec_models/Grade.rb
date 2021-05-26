require_relative '../../src/persistible'

class Grade
  include Persistible
  has_one Numeric, named: :value, default: 5
end