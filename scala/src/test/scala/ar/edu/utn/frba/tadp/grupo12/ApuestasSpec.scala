package ar.edu.utn.frba.tadp.grupo12

import org.scalatest.freespec.AnyFreeSpec

class ApuestasSpec extends AnyFreeSpec{
  "Apostar" - {
    "Jugador apuesta y tiene menos dinero disponible" in {
      val bob_esponja = new Jugador("Bob Esponja",TipoCauto,100)
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50))
      Casino.jugar(apuestas,bob_esponja)
      assert(bob_esponja.monto == 50||bob_esponja.monto == 150)
    }

//    "Jugador apuesta coin" in {
//      val flip = new CoinFlip
//      val bob_esponja = new Jugador(TipoRacional,100)
//      val apuesta = new Apuesta(bob_esponja, new Cara,50)
//      val resultado = flip.jugar(apuesta)
//
//      assert((bob_esponja.dinero == (50+apuesta.monto*2) && resultado) || (bob_esponja.dinero == 50 && !resultado))
//    }

//    "Dos jugadores apuestan roulette" in {
//      val roulette = new Roulette
//      val bob_esponja = new Jugador()
//      val calamardo_tentaculos = new Jugador()
//      val apuesta_bob_rojo = new Apuesta(bob_esponja, new Rojo, 50)
//      val apuesta_calamardo_negro = new Apuesta(calamardo_tentaculos, new Negro, 50)
//
//      roulette.apostar(List(apuesta_bob_rojo, apuesta_calamardo_negro))
//      var resultado = roulette.spin()
//
//      val rojos : List[Int] = List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36)
//      val salioRojo = rojos.contains(resultado)
//      assert(salioRojo && bob_esponja.dinero == 150 && calamardo_tentaculos.dinero == 50 ||
//        !salioRojo && bob_esponja.dinero == 50 && calamardo_tentaculos.dinero == 150)
//    }
  }
}
