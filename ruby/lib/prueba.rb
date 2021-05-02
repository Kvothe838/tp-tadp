require 'tadb'

class Prueba

  attr_accessor :first_name

  TADB::Table.new('bd_Prueba_1')
  table = TADB::DB.table('bd_Prueba_1')
  def materia
    :tadp
  end

  def pruebas
    table = TADB::DB.table('bd_Prueba_1')
    id = table.insert({ subject: 'tadp' })

    entries = table.entries
  end

  #
  # Con lo que esta en prueba se puede ejecutar un minimo test del uso de la gema TABD
  # pry require_relative 'prueba.rb'
  #  dada = Prueba.new
  # table = TADB::DB.table('bd_Prueba_1')
  # id = table.insert({subject: 'tadp'})
  # table.insert({first_name:'casa'})
  # entries = table.entries
  # table.delete("<un id de los de arriba>")
end
module Has_one_

  attr_accessor :first_name, :last_name, :age, :admin, :tipo


  def has_one(tipo, descripcion)
    self.tipo = tipo
    self.first_name = descripcion
  end
end

module Save

  include Has_one_


  def save!
    table = TADB::DB.table('bd_Prueba_1')
    id = table.insert({ apellido: @first_name, nombre: "casa"}) # Aca hay que agregar los demas campos
    ##
    # Aca van a ir el insert
    ##
  end
end

class Persona
  include Has_one_
  include Save

  attr_accessor :first_name, :last_name, :age, :admin, :id

  def initialize
    first_name  = ""
    last_name = ""
    age = 0
    admin = 0
    table = TADB::DB.table('bd_Prueba_1')
  end

end


#
# Ejemplo
#require_relative 'prueba.rb'
# dada = Persona.new
# dada.age = "a"
# dada.has_one(Numeric, dada.age)
# dada.save!
#table = TADB::DB.table('bd_Prueba_1')
#table.entries