class Tabla

  attr_accessor :columnas, :nombre

  def initialize(nombre)
    @columnas = []
    @nombre = nombre
  end

  def repite_columna(nombre_columna)
    @columnas.any? { |obj| obj[:named] == nombre_columna[:named] }
  end

  def agregar_columna!(columna)
    @columnas << columna
  end
end