class Jugador(var dinero: Double = 100) {
  def ganar(monto: Double): Unit = {
    dinero += monto
  }
}
