require 'rspec'
require_relative 'spec_models/Person'
require_relative 'spec_models/AssistantProfessor'
require 'tadb'
require 'pry'

module SpecHelperMethods
  def context
    self.instance_variables.map do |attribute|
      { attribute => self.instance_variable_get(attribute) }
    end
  end
end