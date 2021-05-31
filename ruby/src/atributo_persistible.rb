class AtributoPersistible
  attr_accessor :named, :type, :validations, :default

  def validacion_contenido()
    raise NotImplementedError
  end

  def dame_el_valor(objeto)
    objeto.instance_variable_get("@#{named}")
  end


  def crear_validaciones(from, to, no_blank, validate)
    validations = [type_validation]
    validations << from_validation(from) unless from.nil?
    validations << to_validation(to) unless to.nil?
    validations << no_blank_validation if no_blank
    validations << validate_validation(validate) unless validate.nil?
    self.validations = validations
  end
  def validar!(objeto)
    # validations.all? { |v| objeto.instance_eval(&v) }
    @var = variable_get(objeto)
    puts "#{named}: #{@var} tipo: #{@var.class}"
    validations.all? { |v| @var.instance_eval(&v) }
  end

  def validate_validation(validate)
    validate
  end
  def no_blank_validation
    named = self.named
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"
    puts "DEBERIA Tirar Exception" unless self.to_s.length == 0 || self.is_a?(NilClass)
    # Proc.new { raise TipoIncorrectoException.new mensaje unless self.instance_variable_get("@#{named}").to_s != '' || self.instance_variable_get("@#{named}").is_a?(NilClass) }
    Proc.new { raise TipoIncorrectoException.new "El atributo #{named} no contiene valor en los limites esperados" unless self.to_s.length == 0 }
  end

  def from_validation(_from)
    named = self.named
    from = _from
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"
    # Proc.new { puts "#{self.instance_variable_get("@#{named}")} > #{from}";raise TipoIncorrectoException.new mensaje unless (self.instance_variable_get("@#{named}") > from  || self.instance_variable_get("@#{named}").is_a?(NilClass))}
    Proc.new { puts "#{self} > #{from}";raise TipoIncorrectoException.new mensaje unless (self > from  || self.is_a?(NilClass))}
  end

  def to_validation(_to)
    named = self.named
    to = _to
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"
    # Proc.new { raise TipoIncorrectoException.new mensaje unless self.instance_variable_get("@#{named}") < to  || self.instance_variable_get("@#{named}").is_a?(NilClass)}
    Proc.new { puts "#{self} > #{to}";raise TipoIncorrectoException.new mensaje unless (self < to  || self.is_a?(NilClass))}
  end

  def type_validation
    named = self.named
    type = self.type
    mensaje = "El atributo #{named} no contiene valor de clase #{type}"
    # Proc.new { raise TipoIncorrectoException.new mensaje unless self.instance_variable_get("@#{named}").is_a?(type) || self.instance_variable_get("@#{named}").is_a?(NilClass) }
    Proc.new { raise TipoIncorrectoException.new mensaje unless self.is_a?(type) || self.is_a?(NilClass) }
  end

  def variable_get(objeto)
    objeto.instance_variable_get "@#{named}"
  end

  def variable_set(objeto, valor)
    objeto.instance_variable_set "@#{named}", valor
  end
end

class HasManyPersistible < AtributoPersistible
  def validar!(objeto)
    variable_get(objeto).each {|a| validar_elemento! a}
  end
  def validar_elemento!(elemento)
    validations.all? {|v| elemento.instance_eval(&v)}
  end
  def no_blank_validation
    named = self.named
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"
    Proc.new { raise TipoIncorrectoException.new mensaje unless self.to_s != '' || self.is_a?(NilClass) }
  end

  def from_validation(_from)
    named = self.named
    from = _from
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"

    Proc.new { puts "atributo #{named} > #{from}?";raise TipoIncorrectoException.new mensaje unless self > from || self.is_a?(NilClass)}
  end

  def to_validation(_to)
    named = self.named
    to = _to
    mensaje = "El atributo #{named} no contiene valor en los limites esperados"
    Proc.new { puts "atributo #{named} < #{to}?";raise TipoIncorrectoException.new mensaje unless self < to  || self.is_a?(NilClass)}
  end

  def type_validation
    named = self.named
    type = self.type
    mensaje = "El atributo #{named} no contiene valor de clase #{type}"
    Proc.new { puts "atributo #{named} tipo: #{type}";raise TipoIncorrectoException.new mensaje unless (self.is_a?(type) || self.is_a?(NilClass)) }
  end
end

class HasOnePersistible < AtributoPersistible

end