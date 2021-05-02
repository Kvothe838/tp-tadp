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