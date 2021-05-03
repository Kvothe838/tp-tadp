# frozen_string_literal: true
$tablas = []

# algun comentario
module Persistible

  attr_accessor :id

  def save!
    mi_tabla = get_tabla(self.class.to_s)
    nuevo_hash = Hash.new
    instance_variables.each do |attribute|
      columna = mi_tabla.columnas.find do |col|
        col[:named].to_s == attribute[/[a-z]+(.)+/]
      end
      unless columna.nil?
        valor = instance_variable_get attribute
        nuevo_hash[columna[:named]] ||= valor
      end
    end
    tabla = TADB::DB.table(self.class.to_s)
    @id = tabla.insert(nuevo_hash)
  end

  def refresh!
    tabla = TADB::DB.table(self.class.to_s)
    unless @id.nil?
      una_fila = tabla.entries.find { |fila| fila[:id] == @id }
      una_fila.each do |key, value|
        sym = "@#{key}".to_sym
        instance_variable_set(sym, value)
      end
    end
  end

  def forget!
    tabla = TADB::DB.table(self.class.to_s)
    tabla.delete(@id)
    @id = nil
  end
end

# Agrega al Hash una columna
def has_one(tipo, nombre)
  nombre_tabla = to_s
  una_tabla = get_tabla(nombre_tabla)
  unless una_tabla.repite_columna(nombre)
    una_tabla.agregar_columna!(Hash[:tipo, tipo].merge(nombre))
  end
end

# Busca una tabla o crea una.
def get_tabla(nombre)
  la_tabla = nil
  if !hay_tabla(nombre)
    la_tabla = Columnas.new(nombre)
    $tablas << la_tabla
  else
    la_tabla = $tablas.find { |otra_tabla| otra_tabla.nombre == nombre }
  end
  la_tabla
end

def hay_tabla(nombre)
  $tablas.any? { |otra_tabla| otra_tabla.nombre == nombre }
end
# clase Columnas
class Columnas

  attr_accessor :columnas, :nombre

  def initialize(nombre)
    @columnas = []
    @nombre = nombre
  end

  def repite_columna(nombre_columna)
    @columnas.any? { |obj| obj[:named] == nombre_columna }
  end

  def agregar_columna!(columna)
    @columnas << columna
  end
end