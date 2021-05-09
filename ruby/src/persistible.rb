# frozen_string_literal: true

# algun comentario
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
    end
  end

  def forget!
    tabla = TADB::DB.table(self.class.to_s)
    tabla.delete(@id)
    @id = nil
  end

  # def validar! (tipo, otro_tipo)
  #   return tipo.is_a? otro_tipo
  # end

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

class Tabla

  attr_accessor :columnas, :nombre

  def initialize(nombre)
    @columnas = []
    @nombre = nombre
  end

  def repite_columna(nombre_columna)
    @columnas.any? { |obj| obj[:named] == nombre_columna[:named] }
  end

  def agregar_columna!(columna)
    @columnas << columna
  end
end
