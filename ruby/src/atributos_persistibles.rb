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

      puts nombre_atributo
      puts valor_atributo_instancia.class
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
      nombre_atributo = col[:named]

      if es_tipo_primitivo? tipo_atributo
        valor = objeto.instance_variable_get "@#{col[:named]}"
        a_guardar = valor
        nuevo_hash[col[:named]] ||= a_guardar
      else
        puts valor
        puts col
        #else
        #puts "Oka"
        #Es clase no primitiva, o sea que se usa composicion con esta clase

        #puts valor
        #id_objeto_atributo_instancia = valor.save!
        #a_guardar = id_objeto_atributo_instancia

        ## a_guardar = valor.save!
        #end
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
    una_fila.each do |key, value|
      #tipo_atributo = key[:tipo]
      if es_tipo_primitivo? value.class
        objeto.instance_variable_set("@#{key}", value)
      else
        puts value.class
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