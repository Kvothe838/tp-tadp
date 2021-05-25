describe 'ORM' do
  let(:full_name) { 'Kal' }
  let(:grade) { Grade.new }
  let(:persona) do
    persona = Student.new
    persona.full_name = full_name
    persona.grade = grade
    persona
  end

  before do
    TADB::DB.clear_all
    Student.include(SpecHelperMethods)
  end

  after do
    #TADB::DB.clear_all
  end

  context 'crea estudiante' do
    before do
      grade = Grade.new
      grade.value = 1
      persona.grade=grade
      persona.save!
    end

    it 'Existe el registro en la tabla' do
      expect(persona.id).not_to be_nil
    end
  end
end
