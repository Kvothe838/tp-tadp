require_relative '../../../src/persistible'

class Student_FindBy
  include Persistible

  has_one String, named: :full_name
  has_one Numeric, named: :grade

  def promoted
    self.grade > 8
  end

  def has_last_name(last_name)
    self.full_name.split(' ')[1] === last_name
  end

end

class StudentInferior_FindBy < Student_FindBy
  has_one Numeric, named: :age

  def es_mayor_de_edad
    self.age > 18
  end
end