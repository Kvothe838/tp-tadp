require_relative 'spec_models/forget/Person_Forget.rb'
require_relative 'spec_models/forget/Grade_Forget.rb'
require_relative 'spec_models/forget/Student_Forget.rb'
require_relative 'spec_models/forget/Automovil_Forget.rb'

describe 'test_forget' do
  it 'crea una persona' do
    persona = Person_Forget.new
    persona.first_name = "Juan"
    persona.last_name = "Pérez"
    persona.age = 13
    persona.save!
    persona.forget!

    expect(persona.id).to be_nil
  end
end