package ar.edu.utn.frba.tadp.grupo12

class Apuesta(val tipo: TipoApuesta, val monto: Double)
trait TipoApuesta
case object Cara extends TipoApuesta
case object Cruz extends TipoApuesta
case object PrimerDocena extends TipoApuesta
case object SegundaDocena extends TipoApuesta
case object TercerDocena extends TipoApuesta
case object Rojo extends TipoApuesta
case object Negro extends TipoApuesta
case object Par extends TipoApuesta
case object Impar extends TipoApuesta
case class Numero(valor: Int) extends TipoApuesta