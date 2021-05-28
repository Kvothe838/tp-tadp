require_relative 'spec_models/save-refresh-forget/Person.rb'
require_relative 'spec_models/save-refresh-forget/Grade.rb'
require_relative 'spec_models/save-refresh-forget/Student.rb'
require_relative 'spec_models/save-refresh-forget/Automovil.rb'

describe 'test_save' do
  before do
    TADB::DB.clear_all
  end

  it 'crea una persona' do
    persona = Person.new
    persona.first_name = "Juan"
    persona.last_name = "Pérez"
    persona.age = 13
    persona.save!

    expect(persona.id).not_to be_nil
  end

  it 'crea un student con grade' do
    student = Student.new
    student.full_name = "Juan Pérez"
    student.grade = Grade.new
    student.grade.value = 5
    student.save!

    expect(student.id).not_to be_nil
    expect(student.grade.id).not_to be_nil
  end

  it 'crea un auto que hereda de automovil' do
    auto = Auto.new
    auto.marca = 'VMW'
    auto.rueda = Rueda.new
    auto.rueda.marca = 'Michelin'
    auto.save!

    expect(auto.id).not_to be_nil
    expect(auto.rueda.id).not_to be_nil
  end
end