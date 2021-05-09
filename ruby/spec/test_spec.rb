# frozen_string_literal: true

describe 'ORM' do
  before do
    TADB::DB.clear_all

    #En vez de hacer un include en la clase Person la puedo hacer de esta forma.
    Person.include(Persistible)
  end

  after do
    TADB::DB.clear_all
  end

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

  it 'all_instances' do
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
    expect(personas.first.last_name).to eq('Smith')
    expect(personas.last.last_name).to eq('Wayne')
  end

  it 'find_by_id' do
    persona = Person.new
    persona.last_name = 'Esponja'
    persona.first_name = 'Bob'
    persona.age = 20
    persona.save!
    otra_persona = Person.find_by_id(persona.id).first
    expect(otra_persona.last_name).to eq(persona.last_name)
  end

  it 'find_by_last_name' do
    persona = Person.new
    persona.last_name = 'Esponja'
    persona.first_name = 'Bob'
    persona.age = 20
    persona.save!
    otra_persona = Person.find_by_last_name(persona.last_name).first
    expect(otra_persona.last_name).to eq(persona.last_name)
  end

  it 'find_by_fist_name' do
    persona = Person.new
    persona.last_name = 'Esponja'
    persona.first_name = 'Bob'
    persona.age = 20
    persona.save!
    otra_persona = Person.find_by_first_name(persona.first_name).first
    expect(otra_persona.first_name).to eq(persona.first_name)
  end

  it 'find_by_age' do
    persona = Person.new
    persona.last_name = 'Esponja'
    persona.first_name = 'Bob'
    persona.age = 20
    persona.save!
    otra_persona = Person.find_by_age(persona.age).first
    expect(otra_persona.age).to eq(persona.age)
  end
end
