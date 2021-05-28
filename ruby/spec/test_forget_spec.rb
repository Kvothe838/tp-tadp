require_relative 'spec_models/save-refresh-forget/Person.rb'
require_relative 'spec_models/save-refresh-forget/Grade.rb'
require_relative 'spec_models/save-refresh-forget/Student.rb'
require_relative 'spec_models/save-refresh-forget/Automovil.rb'

describe 'test_forget' do
  before do
    TADB::DB.clear_all
  end

  #TODO Fijarse si tiene que cascadear
  it 'crea una persona' do
    persona = Person.new
    persona.first_name = "Juan"
    persona.last_name = "Pérez"
    persona.age = 13
    persona.save!
    persona.forget!

    expect(persona.id).to be_nil
  end
end