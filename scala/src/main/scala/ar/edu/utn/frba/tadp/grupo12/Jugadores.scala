package ar.edu.utn.frba.tadp.grupo12

case class Jugador(tipo:TipoJugador,var monto:Double){
  def gana(cantidad: Double): Unit ={
    monto += cantidad
    println(s"gane:${cantidad}, ahora tengo ${monto}")
  }
  def pagar(apuesta: Apuesta): Boolean ={
    if(monto >= apuesta.monto){
      monto -= apuesta.monto
      println(s"me quedan ${monto}")
      true
    }else{
      false
    }
  }
}

trait TipoJugador

//Si es un jugador racional, va a ponerle un puntaje a la distribución final de las posibles
// ganancias haciendo la suma de cada posible ganancia * su probabilidad de ocurrencia,
// y va a elegir la lista de juegos que puntúe mejor según ese criterio.
case object TipoRacional extends TipoJugador
//Un jugador arriesgado, en cambio, va a elegir la lista de juegos para la cual el suceso que
// le deje mayor ganancia sea mejor, sin importar la probabilidad del mismo.
case object TipoArriesgado extends TipoJugador
//Un jugador cauto elegiría la sucesión de juegos en la cuál la probabilidad de no perder plata sea mayor.
// O sea, si en uno hay 20% de duplicar, 15% de quedar igual y 70% de quedar en 0,
// y en el otro hay 30% de triplicar, 50% de perder la mitad y 20% de quedar en 0,
// elige los primeros porque tiene 35% de chance de no perder plata vs 30% de chance con los segundos juegos.
case object TipoCauto extends TipoJugador
//También queremos dar la posibilidad al usuario de crear un jugador al que le pasamos un criterio para comparar distribuciones y elige según ese criterio.
case class TipoCriterio(criterio: (TipoApuesta => TipoApuesta)) extends TipoJugador
