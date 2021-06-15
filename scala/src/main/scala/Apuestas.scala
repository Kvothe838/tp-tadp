class Apuesta(val jugador:Jugador, val t:TipoApuesta, val monto: Double){
  jugador.dinero -= monto
}
trait TipoApuesta{
  def probabilidad(): Double
  def gana(r:Int):Boolean
}
class ApuestaCaraOCrus(val cruz: Boolean = false) extends TipoApuesta {
  override def probabilidad(): Double = 0.5

  override def gana(r: Int): Boolean = ???
}

class ApuestoCara extends ApuestaCaraOCrus{
  override def gana(r: Int): Boolean = {
    r == 0
  }
}
class ApuestoCruz extends ApuestaCaraOCrus{
  override def gana(r: Int): Boolean = {
    r==1
  }
}

abstract class ApuestaRulleta extends TipoApuesta{
}
class ParOImpar(val impar: Boolean = false) extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 0.5

  override def gana(r: Int): Boolean = {
    (((r % 2)==1 && impar) || ((r % 2)==0 && !impar)) && r != 0
  }
}
class NegroORojo(val negros: Boolean = false) extends ApuestaRulleta with TipoApuesta {
  val rojos : List[Int] = List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36)
  override def probabilidad(): Double = 0.5
  override def gana(r: Int): Boolean = {
    ((rojos.contains(r) && !negros)||(!rojos.contains(r) && negros))&& r != 0
  }
}
class Numero(val n:Int ) extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 1/37

  override def gana(r: Int): Boolean = {
    r == n
  }
}
class Docena(val docena: Int) extends ApuestaRulleta with TipoApuesta {
  override def probabilidad(): Double = 1/3

  override def gana(r: Int): Boolean = {
    ((r <= 12 && docena == 1)||(r<=24 && docena == 2)||(r<=36 && docena == 2))&& r != 0
  }
}
