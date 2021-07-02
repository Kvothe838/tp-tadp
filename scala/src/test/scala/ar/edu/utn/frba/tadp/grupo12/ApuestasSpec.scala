package ar.edu.utn.frba.tadp.grupo12

import org.scalatest.freespec.AnyFreeSpec

class ApuestasSpec extends AnyFreeSpec{
  "Apostar" - {
    "Jugador apuesta Cara y juega" in {
      val bob_esponja = new Jugador("Bob Esponja",TipoCauto,100)
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),new Apuesta(Tipo(Cara,DistribucionEquiprobable),150))
      val resultado =Casino.jugar(apuestas,bob_esponja)
      println(s"[${resultado.jugador.nombre}] termino sus apuestas con ${resultado.jugador.monto}")
      assert(resultado.jugador.monto == 50||resultado.jugador.monto == 150||resultado.jugador.monto == 300||resultado.jugador.monto == 0)
    }

    "Probabilidad de ganar en una coleccion" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),new Apuesta(Tipo(Cruz,DistribucionEquiprobable),50))
      val proba = Casino.prob_ganar(apuestas)
      assert(proba == 0.25)
    }

    "Combinacion" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),new Apuesta(Tipo(Cruz,DistribucionEquiprobable),50))
      val comb = Casino.combinar(apuestas).toList
      println(comb.flatten)
      assert(comb.length == 4)
    }
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
