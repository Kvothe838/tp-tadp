import org.scalatest.matchers.should.Matchers._
import org.scalatest.freespec.{AnyFreeSpec}

class ApuestasSpec extends AnyFreeSpec{
  "Apostar" - {
    "Jugador apuesta y tiene menos dinero disponible" in {
      val bob_esponja = new Jugador(100)
      val apuesta = new Apuesta(bob_esponja,new ApuestoCara,50)
      val flip = new CoinFlip

      val resultado = flip.jugar(apuesta)
      assert((bob_esponja.dinero == 150 && resultado) || (bob_esponja.dinero == 150 && !resultado))

    }
  }
}
