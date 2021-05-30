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
    validations << no_blank_validation unless no_blank.nil?
    validations << validate_validation(validate) unless validate.nil?
    self.validations = validations
  end
  def validar!(objeto)
    Proc.new { validations.all?[objeto] }
  end

  def validate_validation(validate)
    validate
  end
  def no_blank_validation
    named = self.named
    Proc.new { instance_variable_get("@#{named}").to_s != '' }
  end

  def from_validation(_from)
    named = self.named
    from = _from
    Proc.new { instance_variable_get("@#{named}") >= from }
  end

  def to_validation(_to)
    named = self.named
    to = _to
    Proc.new { instance_variable_get("@#{named}") <= to }
  end

  def type_validation
    named = self.named
    type = self.type
    mensaje = "El atributo #{named} no contiene valor de tipo #{type}"
    Proc.new { instance_variable_get("@#{named}").is_a?(type) }
  end

  def variable_get(objeto)
    objeto.instance_variable_get "@#{named}"
  end

  def variable_set(objeto, valor)
    objeto.instance_variable_set "@#{named}", valor
  end
end

class HasManyPersistible < AtributoPersistible


end

class HasOnePersistible < AtributoPersistible

end