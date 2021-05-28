require_relative '../../../src/persistible'

class Point
  include Persistible

  has_one Numeric, named: :x
  has_one Numeric, named: :y

  def add(other)
    self.x = self.x + other.x
    self.y = self.y + other.y
  end
end