# frozen_string_literal: true
require_relative './atributos_persistibles'
require_relative './persistible_class_methods'
require_relative './tipo_incorrecto_exception'
require 'pry'

# Mixin necesario para la clase que desee implementar un ORM.
module Persistible

  attr_accessor :id

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def initialize
    attr_persistibles.dame_los_many.each do |attribute|
      self.instance_variable_set("@#{attribute[:named]}", [])
    end

    attr_persistibles.atributos.each do |attribute|
      if(attribute[:default] != nil)
        self.instance_variable_set("@#{attribute[:named]}", attribute[:default])
      end
    end
  end

  def save!
    #puts "Inicio: #{self.class}"
    return if attr_persistibles.nil?
    attr_persistibles.validar!(self)
    @id = table.insert(attr_persistibles.dame_el_hash(self))

    attr_persistibles_has_many = attr_persistibles.dame_los_many()
    attr_persistibles_has_many.each do |attribute|
      table_name = "#{self.class.to_s}-#{attribute[:named].to_s}"
      values = instance_variable_get("@#{attribute[:named]}")

      if(values != nil)
        hash_many = Hash[:id, @id]
        una_tabla = TADB::DB.table(table_name)

        #puts "Inicio: #{attribute[:tipo]} #{attribute[:named]}"
        if attr_persistibles.es_tipo_primitivo? attribute[:tipo] #Es primitivo
          values.each do |value|
            otro_hash = hash_many.merge(Hash[:value, value])
            una_tabla.insert(otro_hash)
          end
        else
          values.each do |value|
            value.save!
            #puts value.id
            #puts value.id.class
            otro_hash = hash_many.merge(Hash[:value, value.id])
            una_tabla.insert(otro_hash)
          end
        end
      end
    end
  end

  def refresh!
    if @id.nil?
      puts "Este objeto no tiene id"
      return
    end
    una_fila = self.class.find_by_id_from_table(@id)
    attr_persistibles.refresh!(self, una_fila)
  end

  def forget!
    table.delete(@id)
    @id = nil
  end

  #TODO: Ver como mover a ClassMethods
  self.class.class_eval do
    def define_find_by_method(nombre_columna)
      self.class.define_method("find_by_#{nombre_columna}") do |arg|
        #puts all_instances!
        all_instances!.filter { |instancia|
          #puts arg
          #puts nombre_columna
          #puts instancia.age
          instancia.instance_variable_get("@#{nombre_columna}") == arg }
      end
    end

    unless self.class.instance_methods.include?(:find_by_id)
      define_find_by_method('id')
    end
  end

  private

  def validar!
    attr_persistibles.validar!(self)
  end

  def attr_persistibles
    self.class.attr_persistibles
  end

  def table
    self.class.table
  end
end