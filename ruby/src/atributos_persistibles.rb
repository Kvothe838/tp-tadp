class AtributosPersistibles
  attr_accessor :atributos, :nombre

  def initialize(nombre)
    @atributos = []
    @nombre = nombre
  end

  def repite_columna(named)
    atributos.any? { |obj| obj[:named] == named }
  end

  def agregar_columna!(columna)
    @atributos << columna
  end

  def validar!(objeto)
    atributos.each do |atributo|
      nombre_atributo = atributo[:named]
      valor_atributo_instancia = objeto.instance_variable_get "@#{nombre_atributo}"
      clase_correcta_atributo = atributo[:tipo]

      unless valor_atributo_instancia.is_a? clase_correcta_atributo
        mensaje_exception = "El atributo #{nombre_atributo} no contiene valor de clase #{clase_correcta_atributo}"
        raise TipoIncorrectoException.new mensaje_exception
      end
    end
    nil
  end

  def dame_el_hash(objeto)
    atributos.inject({}) do |nuevo_hash, col|
      valor = objeto.instance_variable_get "@#{col[:named]}"
      tipo_atributo = col[:tipo]
      nombre_atributo = col[:named]

      if es_tipo_primitivo? tipo_atributo
        a_guardar = valor
      else
        #Es clase no primitiva, o sea que se usa composicion con esta clase
        id_objeto_atributo_instancia = valor.save!
        a_guardar = id_objeto_atributo_instancia
      end
      nuevo_hash[col[:named]] ||= a_guardar
      nuevo_hash
    end

  end

  def es_tipo_primitivo?(tipo)
    tipos_primitivos = [String, Numeric, Boolean]
    tipos_primitivos.include? tipo
  end
end