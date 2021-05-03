# frozen_string_literal: true

describe 'ORM' do
  TADB::DB.clear_all
  it 'Crea a Cosmo Kramer de 40, hace un save!, luego cambia a Cosme Fulanito de 25 y hace refresh!' do
    persona = Person.new
    persona.last_name = 'Kramer'
    persona.first_name = 'Cosmo'
    persona.age = 40
    persona.save!
    persona.last_name = 'Fulanito'
    persona.first_name = 'Cosme'
    persona.age = 25
    persona.refresh!
    expect(persona.last_name).to eq('Kramer')
  end
  it 'Crea a Homero Simpson, lo guarda y luego hace un forget!' do
    persona = Person.new
    persona.last_name = 'Simpson'
    persona.first_name = 'Homero'
    persona.age = 2021 - 1956
    persona.save!
    expect(persona.id.nil?).to be false
    persona.forget!
    expect(persona.id.nil?).to be true
    expresion = TADB::DB.table(persona.class.to_s).entries.any? do |fila|
      fila[:last_name] == 'Simpson' && fila[:first_name] == 'Homero'
    end
    expect(expresion).to be false
  end
  it 'All instances' do
    TADB::DB.clear_all
    persona = Person.new
    persona.last_name = 'Smith'
    persona.first_name = 'John'
    persona.age = 69
    persona.save!
    otra_persona = Person.new
    otra_persona.last_name = 'Wayne'
    otra_persona.first_name = 'John'
    otra_persona.age = 96
    otra_persona.save!
    personas = Person.all_instances!
    personas.each do |una_persona|
      puts "Nombre: #{una_persona.last_name},#{una_persona.first_name}  Edad:#{una_persona.age}"
    end
    expect(personas.size).to be 2
  end
end
