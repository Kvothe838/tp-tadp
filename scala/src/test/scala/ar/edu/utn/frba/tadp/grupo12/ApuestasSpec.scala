package ar.edu.utn.frba.tadp.grupo12

import org.scalatest.freespec.AnyFreeSpec


class ApuestasSpec extends AnyFreeSpec{
  "Apostar" - {
    "Jugador apuesta Cara y juega" in {
      val bob_esponja = Jugador("Bob Esponja",TipoCauto,100)
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
//        new Apuesta(Tipo(Cara,DistribucionEquiprobable),0),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),150))
      val resultado =Casino.jugar(apuestas,bob_esponja)
      println(s"[${resultado.jugador.nombre}] termino sus apuestas con ${resultado.jugador.monto}")
      val arbol = ArbolApuestas.generar_arbol_de_apuestas(apuestas,(1,100))
      val resultados_posibles = arbol.dame_tus_hojas.map(a=>a._2)
      assert(resultados_posibles.contains(resultado.jugador.monto))
      assert(resultado.jugador.monto == 50||resultado.jugador.monto == 150||resultado.jugador.monto == 300||resultado.jugador.monto == 0)
    }

    "Probabilidad de ganar en una coleccion" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),new Apuesta(Tipo(Cruz,DistribucionEquiprobable),50))
      val proba = Casino.prob_ganar(apuestas)
      assert(proba == 0.25)
    }

    "Combinacion" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),new Apuesta(Tipo(Cruz,DistribucionEquiprobable),150))
      val comb = Casino.combinar(apuestas)
      val combinatoria = Casino.combinar(apuestas)
      val esperado =List(
        List((Cara,50.0)),
        List((Cruz,150.0)),
        List((Cara,50.0), (Cruz,150.0)),
        List((Cruz,150.0), (Cara,50.0)))
      for {
        apuestas <- comb
      }yield println(apuestas.map(a => (a.tipo.tipoApuesta,a.monto)))
      println(s"combinatoria.length:${combinatoria.length} deberia generar un arbol binario de ${scala.math.pow(2,combinatoria.flatten.length)} hojas")
      val arbol = ArbolApuestas.generar_arbol_de_apuestas(apuestas,(1,100))
      println(s"Un arbol de altura ${arbol.altura} con ${arbol.contar_hojas}")
      println("hojas")
      for {
        hoja <- arbol.dame_tus_hojas
      }yield println(s"hoja:${hoja}")
      println(s"probabilidad de no perder: ${arbol.dame_tus_hojas.filter(h=>h._2 >= 50.0).map(h=>h._1).sum}")
      assert(comb.length == 4)
    }

    "Juegos Sucesivos" in {
      val bob_marley = Jugador("Bob Marley",TipoCauto,15)
      val apuestas = List[Apuesta](
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),10), // Cara 10
        new Apuesta(Tipo(Numero(0),DistribucionEquiprobable),15)) // 0 15
      val chance_de_ganar_550 = Casino.prob_ganar(apuestas)
      assert(chance_de_ganar_550 == 0.5*1/37)
      val monto_final = Casino.jugar(apuestas,bob_marley).jugador.monto
      println(s"monto final: $monto_final")
      assert(monto_final == 5 || monto_final == 550 || monto_final == 10)
    }

    "Jugador Cauto" in {
      val cauto = Jugador("Juan Cauto",TipoCauto,15)
      val apuestas = List[Apuesta](
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),10), // 0.5, las chances de no perder son 0.5
        new Apuesta(Tipo(Numero(0),DistribucionEquiprobable),15), // 1/37
        new Apuesta(Tipo(Par,DistribucionEquiprobable),15), // 18/37
        new Apuesta(Tipo(Numero(2),DistribucionEquiprobable),16)) // 1/37


      println(s" planificacion ${Casino.planificar(cauto,apuestas).map(_.tipo.tipoApuesta)} cantidad ${Casino.planificar(cauto,apuestas).length}")
    }
    "Jugador Arriesgado" in {
      val arriesgado = Jugador("Juan Arriesgado",TipoArriesgado,15)
      val apuestas = List[Apuesta](
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),10), // Cara 10
        new Apuesta(Tipo(Numero(0),DistribucionEquiprobable),15), // 0 15
        new Apuesta(Tipo(Par,DistribucionEquiprobable),15), // 0 15
        new Apuesta(Tipo(Numero(2),DistribucionEquiprobable),16)) // 0 15


      println(s" planificacion ${Casino.planificar(arriesgado,apuestas).map(_.tipo.tipoApuesta)} cantidad ${Casino.planificar(arriesgado,apuestas).length}")
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
