require 'rspec'
require_relative '../lib/Person'
require 'tadb'

module SpecHelperMethods
  def context
    self.instance_variables.map do |attribute|
      { attribute => self.instance_variable_get(attribute) }
    end
  end
end