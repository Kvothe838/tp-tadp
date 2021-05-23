module Persistible
  module ClassMethods
    def all_instances!
      instancias = []
      table.entries.each do |una_fila|
        instancia = new
        instancia.id = una_fila[:id]
        instancia.refresh!
        instancias << instancia
      end
      instancias
    end

    def has_one(tipo, named: raise('named requerido'))
      attr_accessor named.to_sym
      tabla_clase = attr_persistibles
      unless tabla_clase.repite_columna(named)
        tabla_clase.agregar_columna!(Hash[:tipo, tipo].merge(Hash[:named, named]))
        define_find_by_method(named)
      end
    end

    def find_by_id_from_table(id)
      table.entries.find { |fila| fila[:id] == id }
    end

    def attr_persistibles
      @attr_persistibles ||= AtributosPersistibles.new(name)
    end

    def table
      @table ||= TADB::DB.table(name)
    end
  end
end