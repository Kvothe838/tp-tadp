describe 'ORM' do
  let(:full_name) { 'Bob Esponja' }
  let(:grade) { Grade.new }
  let(:persona) do
    persona = Student.new
    persona.full_name = full_name
    persona.grade = grade
    persona.grade.value = 9
    persona
  end
  let(:otra_persona) do
    otra_persona = Student.new
    otra_persona.full_name = "Gari Esponja"
    otro_grade = Grade.new
    otro_grade.value = 2
    otra_persona.grade = otro_grade
    otra_persona
  end
  before do
    TADB::DB.clear_all
    Student.include(SpecHelperMethods)
  end

  after do
    #TADB::DB.clear_all
  end

  context 'find_by_<what>' do
    before do
      persona.save!
      otra_persona.save!
    end

    it 'find_by_promoted' do
      expect(Student.find_by_promoted(true).first.full_name).to eq(persona.full_name)
    end

    it 'find_by_last_name' do
      expect(persona.has_last_name('Esponja')).to be true
      expect(Student.find_by_has_last_name(true,'Esponja').first.full_name).to eq(persona.full_name)
      expect(Student.find_by_has_last_name(true,'Esponja').last.full_name).to eq(otra_persona.full_name)
    end

  end
end
