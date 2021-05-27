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
  
  def es_valor_correcto_segun_clase(valor, clase)
    (valor.nil? && !es_tipo_primitivo?(clase)) || valor.is_a?(clase)
  end

  def validar!(objeto)
    dame_los_one.each do |atributo|
      nombre_atributo = atributo[:named]
      valor_atributo_instancia = objeto.instance_variable_get "@#{nombre_atributo}"
      clase_correcta_atributo = atributo[:tipo]

      unless es_valor_correcto_segun_clase(valor_atributo_instancia, clase_correcta_atributo)
        mensaje_exception = "El atributo #{nombre_atributo} no contiene valor de clase #{clase_correcta_atributo}"
        raise TipoIncorrectoException.new mensaje_exception
      end
    end
    dame_los_many.each do |atributo|
      nombre_atributo = atributo[:named]
      valor_atributo_instancia = objeto.instance_variable_get "@#{nombre_atributo}"
      valor2_atributo_instancia = objeto.instance_variable_get "@full_name"
      puts "variables instancia: #{objeto.instance_variables}"
      puts "nombre_atributo: #{nombre_atributo}"
      puts "valor_atributo_instancia: #{valor_atributo_instancia}"
      puts "valor2_atributo_instancia: #{valor2_atributo_instancia}"
      clase_correcta_atributo = atributo[:tipo]

      son_correctos_todos_elementos = true

      valor_atributo_instancia.each do |elemento_array|
        puts "Elemento: #{elemento_array}"
        #Si un elemento no es válido, la concatenación de && da false. Si todos son válidos, da true.
        son_correctos_todos_elementos = son_correctos_todos_elementos && es_valor_correcto_segun_clase(elemento_array, clase_correcta_atributo)

        #Cascadeo si no es tipo primitivo.
        unless es_tipo_primitivo? clase_correcta_atributo
          son_correctos_todos_elementos = son_correctos_todos_elementos && elemento_array.validar!
        end
      end

      unless son_correctos_todos_elementos
        mensaje_exception = "El atributo #{nombre_atributo} contiene al menos un elemento que no es de clase #{clase_correcta_atributo}"
        raise TipoIncorrectoException.new mensaje_exception
      end
    end
    nil
  end

  def dame_los_many()
    atributos.filter{|a| a[:relation] == "has_many"}
  end

  def dame_los_one()
    atributos.filter{|a| a[:relation] == "has_one"}
  end

  def dame_el_hash(objeto)
    dame_los_one.inject({}) do |nuevo_hash, col|
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
    tipos_primitivos = [String, Numeric, Boolean, Integer]
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
    end

    atributos_has_many = dame_los_many
    #puts atributos_has_many

    atributos_has_many.each do |attribute|

      table_name = "#{objeto.class.to_s}-#{attribute[:named].to_s}"
      tabla_atributo_has_many = TADB::DB.table(table_name)
      arreglo = []

      tipo = attribute[:tipo]
      if es_tipo_primitivo? tipo
        tabla_atributo_has_many.entries.each do |fila|
          arreglo.push(fila[:value])
        end
      else
        tabla_atributo_has_many.entries.each do |fila|

          #arreglo.push(fila[:value])
          valor_aux = Kernel.const_get(tipo.to_s.to_sym).new
          valor_aux.id = fila[:value]
          valor_aux.refresh!
          arreglo.push(valor_aux)
        end
      end

      objeto.instance_variable_set("@#{attribute[:named]}", arreglo)
      #puts tabla_atributo_has_many.entries
    end
  end
end