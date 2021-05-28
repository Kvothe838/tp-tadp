require_relative 'spec_models/has_one/Person.rb'

describe 'test_has_one' do
  it 'Agrega atributos persistibles correctamente' do
    atributos = Person.attr_persistibles.atributos
    expect(atributos.length).to be 4
    expect(atributos[0][:tipo]).to be String
    expect(atributos[0][:named]).to be :first_name
    expect(atributos[1][:tipo]).to be String
    expect(atributos[1][:named]).to be :last_name
    expect(atributos[2][:tipo]).to be Numeric
    expect(atributos[2][:named]).to be :age
    expect(atributos[3][:tipo]).to be Boolean
    expect(atributos[3][:named]).to be :admin
  end

  #Test para cuando se implemente.
  # it 'Pisa el tipo del atributo repetido' do
  #   class Person
  #     has_one String, named: :age
  #   end
  #
  #   atributos = Person_HasOne.attr_persistibles.atributos
  #   expect(atributos[2][:tipo]).to be String
  # end
end