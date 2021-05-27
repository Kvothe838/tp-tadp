
require_relative './Grade.rb'
require_relative '../../src/persistible'

module OtherPerson
  include Persistible
  has_one String, named: :full_name
end

class Student
  include Persistible
  include OtherPerson
  has_one Grade, named: :grade
end

class PersonWithGrades
  include Persistible
  include OtherPerson
  has_many Grade, named: :grades
end