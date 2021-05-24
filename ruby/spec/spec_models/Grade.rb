require_relative '../../src/persistible'

class Grade
  include Persistible
  has_one Numeric, named: :notas

  attr_accessor :notas
end