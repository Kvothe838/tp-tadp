
require_relative './Grade.rb'
require_relative '../../src/persistible'

module OtherPerson
  include Persistible
  has_one String, named: :full_name, no_blank: true
  has_one Numeric, named: :age, from: 18, to: 100
  has_many Grade, named: :grades, validate: proc{ value > 2 }
end

class Student
  include Persistible
  include OtherPerson
  has_one Numeric, named: :age, from: 18, to: 100
  has_one Grade, named: :grade

  def promoted
    self.grade.value > 8
  end

  def has_last_name(last_name)
    self.full_name.split(' ')[1] === last_name
  end

end

class PersonWithGrades
  include Persistible
  include OtherPerson
  has_many Grade, named: :grades
end

class PersonWithStudents
  include Persistible
  include OtherPerson
  has_many Student, named: :students
end