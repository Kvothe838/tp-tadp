module Persistible
  module ClassMethods
    def all_instances!
      instancias = []
      descendants.each do |descendant|
        table_descendant = descendant.table
        table_descendant.entries.each do |una_fila|
          instancia = descendant.new
          instancia.id = una_fila[:id]
          instancia.refresh!
          instancias << instancia
        end
      end


      table.entries.each do |una_fila|
        instancia = new
        instancia.id = una_fila[:id]
        instancia.refresh!
        instancias << instancia
      end
      #puts instancias
      instancias
    end

    def descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def get_validates(no_blank, from, to, validate)
      validates = []
      if(no_blank!=nil)
        validates << Hash[:no_blank, no_blank]
      end
      if(from!=nil)
        validates << Hash[:from, from]
      end
      if(to!=nil)
        validates << Hash[:to, to]
      end
      if(validate!=nil)
        validates << Hash[:validate, validate]
      end
      validates
    end

    def has_many(tipo, named: raise('named requerido'), no_blank: nil, from: nil, to: nil, validate: nil)
      has_field(tipo, named, no_blank, from, to, validate, "has_many")
    end

    def has_one(tipo, named: raise('named requerido'), no_blank: nil, from: nil, to: nil, validate: nil)
      has_field(tipo, named, no_blank, from, to, validate, "has_one")
    end

    def has_field(tipo, named, no_blank, from, to, validate, relation)
      validates = get_validates(no_blank, from, to, validate)

      #puts "Self: #{self}"
      #puts "Ancestors: #{self.ancestors}"
      ancestors_persistibles = self.ancestors.filter {|a| a.include? (Persistible)}
      #puts "Inicio #{ancestors_persistibles}"

      atributos_ancestros = []
      ancestors_persistibles.each do |ancestor|
        atributos_ancestros = atributos_ancestros + ancestor.attr_persistibles.atributos
      end

      attr_accessor named.to_sym
      tabla_clase = attr_persistibles

      #puts "Atr: #{atributos_ancestros}"
      atributos_ancestros.each do |atributo|
        tabla_clase.agregar_columna!(atributo)
      end

      unless tabla_clase.repite_columna(named)
        tabla_clase.agregar_columna!(Hash[:tipo, tipo].merge(Hash[:named, named]).merge(Hash[:validates, validates].merge(Hash[:relation, relation])))
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