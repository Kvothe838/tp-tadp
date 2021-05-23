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


  def save!
    return if attr_persistibles.nil?
    @id = table.insert(attr_persistibles.dame_el_hash(self))

  end

  def refresh!
    if @id.nil?
      puts "Este objeto no tiene id"
      return
    end

    #obtengo la fila con el id
    una_fila = self.class.find_by_id_from_table(@id)
    # por cada par key => value en la fila, con instance_variable_set le asigno el value al symbol
    # (casteado desde string) que es @algo ej @first_name
    una_fila.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def forget!
    table.delete(@id)
    @id = nil
  end

  #TODO: Ver como mover a ClassMethods
  self.class.class_eval do
    def define_find_by_method(nombre_columna)
      self.class.define_method("find_by_#{nombre_columna}") do |arg|
        all_instances!.filter { |instancia|
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