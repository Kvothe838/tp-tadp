require_relative './boolean'
require_relative './atributo_persistible'
class AtributosPersistibles
  attr_accessor :atributos, :nombre

  def initialize(nombre)
    @atributos = []
    @nombre = nombre
  end

  def repite_nombre_columna(named)
    atributos.any? { |obj| obj.named == named }
  end

  def repite_columna?(columna)
    atributos.any? { |obj| obj === columna }
  end

  def agregar_columna!(columna)
    if repite_nombre_columna(columna.named)
      columna_repetida = atributos.find{ |obj| obj.named == columna.named }
      unless columna_repetida.nil?
        columna_repetida.type = columna.type
        columna_repetida.validations = columna.validations
        # columna_repetida[:relation] = columna[:relation]
        columna_repetida.default = columna.default
      end
    else
      atributos << columna
    end
  end

  def es_valor_correcto_segun_clase(valor, clase)
    (valor.nil? && !es_tipo_primitivo?(clase)) || valor.is_a?(clase)
  end

  def validar!(objeto)
    atributos.each do |atributo|

      # unless atributo.validar_tipo(objeto)
      # unless validacion_contenido(atributo,objeto)
      unless atributo.validar!(objeto)
        mensaje_exception = "El atributo #{atributo.named} no contiene valor en los limites esperados"
        raise TipoIncorrectoException.new mensaje_exception
      end
    end
    nil
  end

  def dame_los_many()
    atributos.filter{ |a| a.is_a? HasManyPersistible }
  end

  def dame_los_one()
    atributos.filter{ |a| a.is_a? HasOnePersistible }
  end

  def dame_el_hash(objeto)
    # puts "clase dame hash #{objeto.class}"
    # puts dame_los_one.map { |a| a.named }

    dame_los_one.inject({}) do
    |nuevo_hash,atributo|
      tipo_atributo = atributo.type
      valor = atributo.variable_get(objeto)
      if es_tipo_primitivo? tipo_atributo
        a_guardar = valor
        nuevo_hash[atributo.named] ||= a_guardar
      else
        if valor.class != NilClass
          valor.save!
          a_guardar = valor.id
          nuevo_hash[atributo.named] ||= a_guardar
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
    # obtengo la fila con el id
    # una_fila = objeto.class.find_by_id_from_table(objeto.id)
    # por cada par key => value en la fila, con instance_variable_set le asigno el value al symbol
    # (casteado desde string) que es @algo ej @first_name
    # puts una_fila
    # puts atributos
    una_fila.each do |key, value|
      class_atributo = String
      if key != :id
        atributo = atributos.find { |a| a.named == key }
        class_atributo = atributo.type
      end

      if es_tipo_primitivo? class_atributo
        objeto.instance_variable_set("@#{key}", value)
      else
        # A mejorar esta parte e identitificar porque en los tests es nulo
        valor_aux = Kernel.const_get(class_atributo.to_s.to_sym).new
        valor_aux.id = value
        valor_aux.refresh!
        objeto.instance_variable_set("@#{key}", valor_aux)
      end
    end

    atributos_has_many = dame_los_many
    # puts atributos_has_many

    atributos_has_many.each do |attribute|

      table_name = "#{objeto.class.to_s}-#{attribute.named.to_s}"
      tabla_atributo_has_many = TADB::DB.table(table_name)
      arreglo = []

      tipo = attribute.type
      if es_tipo_primitivo? tipo
        tabla_atributo_has_many.entries.each do |fila|
          arreglo.push(fila[:value])
        end
      else
        tabla_atributo_has_many.entries.each do |fila|

          # arreglo.push(fila[:value])
          valor_aux = Kernel.const_get(tipo.to_s.to_sym).new
          valor_aux.id = fila[:value]
          valor_aux.refresh!
          arreglo.push(valor_aux)
        end
      end

      objeto.instance_variable_set("@#{attribute.named}", arreglo)
      # puts tabla_atributo_has_many.entries
    end
  end
end


def validacion_contenido(atributo,objeto ) #atributo
  inferior = true
  superior = true
  tiene_Contenido = true
  validate_bloque = true
  nombre_atributo = atributo[:named]
  validates = atributo[:validates]
  validates.each do |limit|

    if (limit[:no_blank] && atributo[:relation] == "has_one")
      tiene_Contenido = ((objeto.instance_variable_get "@#{nombre_atributo}").to_s !=  '' )
    else if (limit[:from] && atributo[:relation] == "has_one")
           inferior = (objeto.instance_variable_get "@#{nombre_atributo}") > limit[:from]
         else if (limit[:to] && atributo[:relation] == "has_one")
                superior = (objeto.instance_variable_get "@#{nombre_atributo}") < limit[:to]
              else if (limit[:validate])
                     #puts "Objeto: #{objeto}"
                     if(atributo[:relation] == "has_one")
                       validate_bloque =  objeto.ejecutar_proc(limit[:validate])
                     else
                       value_atributo = objeto.instance_variable_get "@#{nombre_atributo}"
                       value_atributo.each do |elemento_array|
                         validate_bloque =  elemento_array.ejecutar_proc(limit[:validate])
                         if(!validate_bloque)
                           break
                         end
                       end
                     end
                   else
                     puts "No contemplado"
                   end
              end
         end
    end
  end
  devuelve = superior && inferior && tiene_Contenido && validate_bloque
  #tiene_Contenido = superior && inferior
  #tiene_Contenido
  devuelve
end