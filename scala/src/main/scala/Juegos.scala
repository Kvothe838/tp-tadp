import scala.collection.mutable.ListBuffer

class CoinFlip {
  def jugar(a:Apuesta): Unit ={
    if(scala.util.Random.nextInt(1) == 1){
      if(a.t.isInstanceOf[CaraOCrus]){
        if(a.t.asInstanceOf[CaraOCrus].cruz){
          a.jugador.ganar(a.monto*2)
        }
      }
    }
  }
}

class Roulette {
  val apuestas:ListBuffer[Apuesta] = ListBuffer()
  def apostar(nuevas_apuestas:List[Apuesta]): Unit ={
    apuestas.addAll(nuevas_apuestas)
  }
  def spin(): Unit ={
    var r = scala.util.Random.nextInt(37)

  }
}
