require_relative '../../../src/persistible'

class Rueda
  include Persistible

  has_one String, named: :marca
end

class Automovil
  include Persistible

  has_one Rueda, named: :rueda
end

class Auto < Automovil
  has_one String, named: :marca
end