package ar.edu.utn.frba.tadp.grupo12
import org.scalatest.freespec.AnyFreeSpec

import scala.math.Ordering.Implicits.seqOrdering
class ArbolSpec extends AnyFreeSpec{
  "Arbol" - {
    "La altuda es igual al numero de apuestas" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),150))
      val arbol = Casino.generar_arbol_de_apuestas(apuestas,(1,100))
      assert(arbol.altura == apuestas.length)
    }
    "El numero de hojas es igual a 2^(numero de apuestas) o igual a 2^(altura del arbol)" in {
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),150))
      val arbol = Casino.generar_arbol_de_apuestas(apuestas,(1,100))
      assert(arbol.contar_hojas == scala.math.pow(2,apuestas.length))
      assert(arbol.contar_hojas == scala.math.pow(2,arbol.altura))
    }
    "El resultado de las apuestas  del Jugador esta contenido en las hojas del arbol" in {
      val bob_esponja = Jugador("Bob Esponja",TipoCauto,100)
      val apuestas = List[Apuesta](new Apuesta(Tipo(Cara,DistribucionEquiprobable),50),
        new Apuesta(Tipo(Cara,DistribucionEquiprobable),150))
      val resultado =Casino.jugar(apuestas,bob_esponja)
      val arbol = Casino.generar_arbol_de_apuestas(apuestas,(1,100))
      val hojas_del_arbol_monto = arbol.dame_tus_hojas.map(a=>a._2)
      assert(hojas_del_arbol_monto.contains(resultado.jugador.monto))
    }
    "Aplicaciones del Arbol en el contexto de la planificacion" in {
      val primerDocena: Double => Apuesta = monto => new Apuesta(Tipo(PrimerDocena,DistribucionEquiprobable),monto)
      // Paso 1) Obtengo las hojas del Arbol generado con una de las posibles combinaciones, el (1,100) es un valor inicial, o semilla,
      // similar a lo que se usa en el foldLeft, 1 es la semilla de probabilidad y 100 el monto
      val resultados = Casino.generar_arbol_de_apuestas(List(primerDocena(50),primerDocena(30)),(1,100)).dame_tus_hojas
      // Paso 2) Filtro los resultados que tienen la forma (Probabilidad, Monto) segun lo que me interese, en este caso me interesa saber cuales de esos resultados terminan con montos menores a 100 o mayores o iguales a 100
      val resultados_con_montos_menores_a_100 = resultados.filter(a=>a._2 < 100)
      val resultados_con_montos_mayores_a_100 = resultados.filter(a=>a._2 >= 100)
      println(s"Resultados posibles que tienen un monto MENOR a 100:${resultados_con_montos_menores_a_100}")
      println(s"Resultados posibles que tienen un monto MAYOR o IGUAL a 100:${resultados_con_montos_mayores_a_100}")
      // Paso 3) Me interesa saber cual es la probabilidad de que termine con montos menores a 100 o montos mayores o iguales a 100
      val probabilidad_de_que_el_monto_sea_mayor_a_100 = resultados_con_montos_mayores_a_100.map(a=>a._1).sum
      println(s"Esto significa que la probabilidad de tener un resultado MENOR a 100 es:${resultados_con_montos_menores_a_100.map(a=>a._1).sum}")
      println(s"Esto significa que la probabilidad de tener un resultado MAYOR o IGUAL a 100 es:${probabilidad_de_que_el_monto_sea_mayor_a_100}")
      // Paso 4) Verifico que la suma de las probabilidades de tener un monto menor a 100 y las de tener un monto mayor o igual a 100 sea igual a 1.
      assert(resultados_con_montos_menores_a_100.map(a=>a._1).sum+probabilidad_de_que_el_monto_sea_mayor_a_100 == 1)
    }
  }
}
