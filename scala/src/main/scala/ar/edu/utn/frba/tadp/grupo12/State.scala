package ar.edu.utn.frba.tadp.grupo12

object State {
  def apply(jugador: => Jugador): State = try {
    Betting(jugador)
  } catch {
    case error: Exception => StandBy(jugador)
  }

}
sealed trait State {
  def jugador: Jugador
  def map(f: Jugador => Jugador): State
  def flatMap(f: Jugador => State): State
  def hacerApuesta(apuesta: Apuesta):State
  def gana(cantidad: Double):State
}

case class Betting(jugador: Jugador) extends State {
  def map(f: Jugador => Jugador) = State(f(jugador))
  def flatMap(f: Jugador => State) = f(jugador)
  def hacerApuesta(apuesta: Apuesta):State = {
    println(s"[${jugador.nombre}] hacer apuesta ${apuesta.monto} a ${apuesta.tipo.tipoApuesta}")
    pagar(apuesta)
    val resultado = Casino.evaluar(apuesta,copy(jugador.pagar(apuesta)))
    resultado
  }
  def gana(cantidad: Double) ={
    copy(Jugador(jugador.nombre,jugador.tipo,jugador.monto+cantidad))
  }
  def pagar(apuesta: Apuesta) = {
    copy(Jugador(jugador.nombre,jugador.tipo,(jugador.monto - apuesta.monto).max(0)))
  }
}

case class StandBy(jugador: Jugador) extends State {
  def hacerApuesta(apuesta: Apuesta) = this

  def map(f: Jugador => Jugador): State = this

  def flatMap(f: Jugador => State): State = this

  def gana(cantidad: Double): State = this
}
