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
      tipo_atributo = col[:tipo]

      valor = objeto.instance_variable_get "@#{col[:named]}"
      if es_tipo_primitivo? tipo_atributo
        a_guardar = valor
        nuevo_hash[col[:named]] ||= a_guardar
      else
        #Guardamos el id del objeto (tipo no primitivo)
        if(valor.class!=NilClass)
          valor.save!
          a_guardar = valor.id
          nuevo_hash[col[:named]] ||= a_guardar
        end
      end
      nuevo_hash
    end

  end

  def es_tipo_primitivo?(tipo)
    tipos_primitivos = [String, Numeric, Boolean, FalseClass, TrueClass, Integer]
    ## TODO: Mejorar --> ver que pasas con boolean, funciona como esta ahora
    tipos_primitivos.include? tipo
  end

  def refresh!(objeto, una_fila)
    #obtengo la fila con el id
    #una_fila = objeto.class.find_by_id_from_table(objeto.id)
    # por cada par key => value en la fila, con instance_variable_set le asigno el value al symbol
    # (casteado desde string) que es @algo ej @first_name
    #puts una_fila
    #puts atributos
    una_fila.each do |key, value|
      valor_aux = objeto.instance_variable_get "@#{key}"

      class_atributo = String
      if(key.to_s != "id")
        class_atributo = atributos.find { |a| a[:named] == key }[:tipo]
      end

      if es_tipo_primitivo? class_atributo
        objeto.instance_variable_set("@#{key}", value)
      else
        #A mejorar esta parte e identitificar porque en los tests es nulo
        valor_aux = Kernel.const_get(class_atributo.to_s.to_sym).new
        valor_aux.id = value
        valor_aux.refresh!
        objeto.instance_variable_set("@#{key}", valor_aux)
      end
      #Es clase no primitiva, o sea que se usa composicion con esta clase
      # id_objeto_atributo_instancia = tipo_atributo.refresh!
      #   a_refrescar = id_objeto_atributo_instancia
      #end
      #    dato_no_primitivo --> Guardar con un nombre que nos permita recuperar
      #
      # valor = objeto.instance_variable_get "@#{col[:named]}"
      #    tipo_atributo = col[:tipo]
      #    nombre_atributo = col[:named]

      #    if es_tipo_primitivo? tipo_atributo
      #      a_refrescar = valor
      #    else
      #      #Es clase no primitiva, o sea que se usa composicion con esta clase
      #      id_objeto_atributo_instancia = valor.save!
      #      a_refrescar = id_objeto_atributo_instancia
      #    end
      #    nuevo_hash[col[:named]] ||= a_refrescar
    end
  end
end