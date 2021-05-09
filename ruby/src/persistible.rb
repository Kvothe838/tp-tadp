# frozen_string_literal: true

# algun comentario
module Persistible

  attr_accessor :id, :table

  def save!
    nuevo_hash = Hash.new

    @@tabla.columnas.each do |col|
      valor = instance_variable_get "@#{col[:named]}"
        nuevo_hash[col[:named]] ||= valor
    end

    # instance_variables.each do |attribute|
    #   columna = @@tabla.columnas.find do |col|
    #     col[:named].to_s == attribute[/[a-z]+(.)+/]
    #   end
    #   unless columna.nil? #es nil cuando atributo no es persistente, osea no tiene has_one o has_many
    #     valor = instance_variable_get attribute
    #     nuevo_hash[columna[:named]] ||= valor
    #   end
    # end

    tabla = TADB::DB.table(self.class.to_s)
    @id = tabla.insert(nuevo_hash)
  end

  def refresh!
    tabla = TADB::DB.table(self.class.to_s)
    unless @id.nil?
      #obtengo la fila con el id
      una_fila = tabla.entries.find { |fila| fila[:id] == @id }
      # por cada par key => value en la fila, obtengo el symbol del atributo a partir de key,
      # y con instance_variable_set le asigno el value a el symbol que es @algo ej @first_name
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

  # def validar! (tipo, otro_tipo)
  #   return tipo.is_a? otro_tipo
  # end

  self.class.class_eval do
    @@tabla = nil

    unless self.class.instance_methods.include?(:find_by_id)
      self.class.define_method("find_by_id") do |arg|
        self.all_instances!.filter { |instancia| instancia.instance_variable_get("@id") === arg }
      end
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
      una_tabla = get_tabla(nombre_tabla)
      unless una_tabla.repite_columna(dato)
        una_tabla.agregar_columna!(Hash[:tipo, tipo].merge(dato))
        self.class.define_method("find_by_#{dato[:named]}") do |arg|
          self.all_instances!.filter { |instancia|
            instancia.instance_variable_get("@#{dato[:named]}") === arg }
        end
      end
    end

    def get_tabla(nombre)
      if @@tabla.nil?
        @@tabla = Columnas.new(nombre)
      end
      @@tabla
    end

  end
end

class Columnas

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
