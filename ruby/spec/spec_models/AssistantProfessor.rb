require_relative '../../src/persistible'

class AssistantProfessor < Student
  include Persistible
  has_one String, named: :type
end
