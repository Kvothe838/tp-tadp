import scala.collection.mutable.ListBuffer

class CoinFlip {
  def jugar(a:Apuesta): Boolean ={
    if(a.t.gana(scala.util.Random.nextInt(2))){
      a.jugador.ganar(a.monto*1/a.t.probabilidad())
      true
    }
    false
  }
}

class Roulette {
  val apuestas:ListBuffer[Apuesta] = ListBuffer()
  def apostar(nuevas_apuestas:List[Apuesta]): Unit ={
    apuestas.addAll(nuevas_apuestas)
  }
  def spin(): Unit ={
    val r = scala.util.Random.nextInt(37)
    apuestas.foreach(a => if(a.t.gana(r)){a.jugador.ganar(a.monto*1/a.t.probabilidad())})
  }
}
