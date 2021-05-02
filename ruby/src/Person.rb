require 'tadb'

module Has_one_

  attr_accessor :first_name, :last_name, :age, :admin, :tipo

  def has_one(tipo, descripcion)
    self.tipo = tipo
    self.first_name = descripcion
  end
end

module Persistible_object

  include Has_one_
  attr_accessor :id, :table
  #Posteriormente, table debe ser una variable de tipo privado para no ensuciar la interfaz

  def save!
    self.table = TADB::DB.table('bd_Prueba_1')
    self.id = table.insert({ apellido: @first_name, nombre: "casa"}) # Aca hay que agregar los demas campos
    ##
    # Aca van a ir el insert
    ##
  end

  def refresh!
    #Implementar lógica
  end

  def forget!
    self.table.delete(self.id)
    self.id = nil
  end
end

class Prueba
  attr_accessor :energia
end

class Persona
  include Has_one_
  include Persistible_object
  
  attr_accessor :first_name, :last_name, :age, :admin

  def initialize
    first_name  = ""
    last_name = ""
    age = 0
    admin = 0
  end

end


#
# Ejemplo
#require_relative './src/Person.rb'
# dada = Persona.new
# dada.age = "a"
# dada.has_one(Numeric, dada.age)
# dada.save!
#table = TADB::DB.table('bd_Prueba_1')
#table.entries