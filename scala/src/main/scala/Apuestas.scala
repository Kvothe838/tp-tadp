class Apuesta(val jugador: Jugador, val tipoApuesta: TipoApuesta, val monto: Double){
  jugador.dinero -= monto
}

trait TipoApuesta{
  def probabilidad(): Double
  def gana(r:Int):Boolean
}

abstract class CaraOCruz(val cruz: Boolean = false) extends TipoApuesta {
  override def probabilidad(): Double = 0.5

  override def gana(r: Int): Boolean = ???
}

class Cara extends CaraOCruz {
  override def gana(r: Int): Boolean = {
    r == 0
  }
}
class Cruz extends CaraOCruz {
  override def gana(r: Int): Boolean = {
    r == 1
  }
}

abstract class ApuestaRulleta extends TipoApuesta {
}

abstract class ParOImpar extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 0.5

  override def gana(r: Int): Boolean = {
    r != 0
  }
}

class Par extends ParOImpar {
  override def gana(r: Int): Boolean = {
    r % 2 == 0  && super.gana(r)
  }
}

class Impar extends ParOImpar {
  override def gana(r: Int): Boolean = {
    r % 2 ==1 && super.gana(r)
  }
}

abstract class NegroORojo extends ApuestaRulleta with TipoApuesta {
  val rojos : List[Int] = List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36)

  override def probabilidad(): Double = 0.5

  override def gana(r: Int): Boolean = {
    r != 0
  }
}

class Negro extends NegroORojo {
  override def gana(r: Int): Boolean = {
    !rojos.contains(r) && super.gana(r)
  }
}

class Rojo extends NegroORojo {
  override def gana(r: Int): Boolean = {
    rojos.contains(r)
  }
}

class Numero(val n:Int ) extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 1/37

  override def gana(r: Int): Boolean = {
    r == n
  }
}
abstract class Docena extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 1/3

  override def gana(r: Int): Boolean = {
    r != 0
  }
}

class PrimeraDocena extends Docena {
  override def gana(r: Int): Boolean = {
    r <= 12 && super.gana(r)
  }
}

class SegundaDocena extends Docena {
  override def gana(r: Int): Boolean = {
    r > 12 && r <= 24 && super.gana(r)
  }
}

class TerceraDocena extends Docena {
  override def gana(r: Int): Boolean = {
    r > 24 && r <= 36 && super.gana(r)
  }
}
