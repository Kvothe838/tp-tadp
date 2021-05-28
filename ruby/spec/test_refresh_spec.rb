require_relative 'spec_models/save-refresh-forget/Person.rb'
require_relative 'spec_models/save-refresh-forget/Grade.rb'
require_relative 'spec_models/save-refresh-forget/Student.rb'
require_relative 'spec_models/save-refresh-forget/Automovil.rb'

describe 'test_refresh' do
  before do
    TADB::DB.clear_all
  end

  it 'resetea una persona' do
    persona = Person.new
    persona.first_name = "Juan"
    persona.last_name = "Pérez"
    persona.age = 13
    persona.save!

    persona.first_name = "Pedro"
    persona.refresh!

    expect(persona.first_name).to eq("Juan")
  end

  it 'resetea el grade del student' do
    student = Student.new
    student.full_name = "Juan Pérez"
    student.grade = Grade.new
    student.grade.value = 5
    student.save!

    student.grade.value = 10
    student.refresh!

    expect(student.grade.value).to be 5
  end

  it 'crea un auto que hereda de automovil' do
    auto = Auto.new
    auto.marca = 'VMW'
    auto.rueda = Rueda.new
    auto.rueda.marca = 'Michelin'
    auto.save!

    auto.rueda.marca = 'Goodyear'
    auto.refresh!

    expect(auto.rueda.marca).to eq('Michelin')
  end
end