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
      nuevo_hash[col[:named]] ||= valor
      nuevo_hash
    end
  end
end