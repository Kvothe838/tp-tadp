# frozen_string_literal: true
require_relative './tabla'
require_relative './tipo_incorrecto_exception'

# Mixin necesario para la clase que desee implementar un ORM.
module Persistible

  attr_accessor :id, :table

  def save!
    nuevo_hash = Hash.new

    unless @@tabla.nil?
      @@tabla.columnas.each do |col|
        valor = instance_variable_get "@#{col[:named]}"
        nuevo_hash[col[:named]] ||= valor
      end

      tabla = TADB::DB.table(self.class.to_s)
      @id = tabla.insert(nuevo_hash)
    end
  end

  def refresh!
    tabla = TADB::DB.table(self.class.to_s)
    unless @id.nil?
      #obtengo la fila con el id
      una_fila = tabla.entries.find { |fila| fila[:id] == @id }
      # por cada par key => value en la fila, con instance_variable_set le asigno el value al symbol
      # (casteado desde string) que es @algo ej @first_name
      una_fila.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    else
      puts "Este objeto no tiene id"
    end
  end

  def forget!
    tabla = TADB::DB.table(self.class.to_s)
    tabla.delete(@id)
    @id = nil
  end

  def validar!
    @@tabla.columnas.each do |atributo|
      nombre_atributo = atributo[:named]
      valor_atributo_instancia = instance_variable_get "@#{nombre_atributo}"
      clase_correcta_atributo = atributo[:tipo]

      unless valor_atributo_instancia.is_a? clase_correcta_atributo
        mensaje_exception = "El atributo #{nombre_atributo} no contiene valor de clase #{clase_correcta_atributo}"
        raise TipoIncorrectoException.new mensaje_exception
      end
    end
    nil
  end

  self.class.class_eval do
    @@tabla = nil

    def define_find_by_method(nombre_columna)
      self.class.define_method("find_by_#{nombre_columna}") do |arg|
        all_instances!.filter { |instancia|
          instancia.instance_variable_get("@#{nombre_columna}") == arg }
      end
    end

    unless self.class.instance_methods.include?(:find_by_id)
      define_find_by_method('id')
    end

    def all_instances!
      instancias = []
      filas = TADB::DB.table(to_s).entries
      filas.each do |una_fila|
        instancia = new
        instancia.id = una_fila[:id]
        instancia.refresh!
        instancias << instancia
      end
      instancias
    end

    def has_one(tipo, dato)
      nombre_tabla = to_s
      tabla_clase = get_tabla(nombre_tabla)
      unless tabla_clase.repite_columna(dato)
        tabla_clase.agregar_columna!(Hash[:tipo, tipo].merge(dato))
        nombre_columna = dato[:named]
        define_find_by_method(nombre_columna)
      end
    end

    def get_tabla(nombre)
      @@tabla = Tabla.new(nombre) if @@tabla.nil?
      @@tabla
    end

  end
end

