import scala.collection.mutable.ListBuffer

abstract class Juego {
  def aplicarJuego(apuesta: Apuesta, n: Int): Boolean = {
    val gana: Boolean = apuesta.tipoApuesta.gana(n)

    if(gana) {
      apuesta.jugador.ganar(apuesta.monto * 1 / apuesta.tipoApuesta.probabilidad())
    }

    gana
  }
}

class CoinFlip extends Juego {
  def jugar(apuesta: Apuesta): Boolean = {
    val caraOCruz = scala.util.Random.nextInt(2)

    aplicarJuego(apuesta, caraOCruz)
  }
}

class Roulette extends Juego {
  val apuestas: ListBuffer[Apuesta] = ListBuffer()

  def apostar(nuevas_apuestas: List[Apuesta]): Unit = {
    apuestas.addAll(nuevas_apuestas)
  }

  def spin(): Int = {
    val numeroRandom = scala.util.Random.nextInt(37)
    apuestas.foreach(apuesta => aplicarJuego(apuesta, numeroRandom))
    numeroRandom
  }
}
