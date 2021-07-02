package ar.edu.utn.frba.tadp.grupo12


import scala.math.Ordering.Implicits.seqOrdering
import scala.util.{Success, Try}

object Casino {
  type Apuestas = List[Apuesta]


  //No estoy seguro que que voy a hacer con esto, podría devolver Apuestas.
//  val combinar: Apuestas => List[Apuestas] = apuestas =>  {
//    println(s"apuestas.lenght ${apuestas.length}")
//    apuestas.toSet[Apuesta].subsets.toList
//  }
  def combinar[T](seq: Seq[T]) : Iterable[Seq[T]] = {
    (1 to seq.length).view.flatMap(i => seq.combinations(i).flatMap(_.permutations)).toList
  }
  val prob_ganar: Apuestas => Double = apuestas => apuestas.map(apuesta => probabilidad(apuesta)).reduce(_*_)
  //TODO ver como es esto de probabilidad de no perder
  val prob_no_perder: Apuestas => Double = apuestas => prob_ganar(apuestas) + apuestas.map(apuesta => probabilidad(apuesta)).reduce(_+_)/apuestas.length
  val criterio_racional: Apuestas => Double = apuestas => prob_ganar(apuestas)*1/prob_ganar(apuestas)
  val criterio_arriesgado: Apuestas => Double = apuestas => 1/prob_ganar(apuestas)
  def planificar(jugador:Jugador, posibles_apuestas:Apuestas): Apuestas ={
    jugador.tipo match {
      //Un jugador cauto elegiría la sucesión de juegos en la cuál la probabilidad de no perder plata sea mayor.
      // O sea, si en uno hay 20% de duplicar, 15% de quedar igual y 70% de quedar en 0,
      // y en el otro hay 30% de triplicar, 50% de perder la mitad y 20% de quedar en 0,
      // elige los primeros porque tiene 35% de chance de no perder plata vs 30% de chance con los segundos juegos.
      case TipoCauto => {
        combinar(posibles_apuestas).maxBy(apuestas => prob_no_perder(apuestas.toList)).toList
      }
      //Si es un jugador racional, va a ponerle un puntaje a la distribución final de las posibles
      // ganancias haciendo la suma de cada posible ganancia * su probabilidad de ocurrencia,
      // y va a elegir la lista de juegos que puntúe mejor según ese criterio.
      case TipoRacional => {
        combinar(posibles_apuestas).maxBy(apuestas => criterio_racional(apuestas.toList)).toList
      }
      //Un jugador arriesgado, en cambio, va a elegir la lista de juegos para la cual el suceso que
      // le deje mayor ganancia sea mejor, sin importar la probabilidad del mismo.
      case TipoArriesgado => {
        combinar(posibles_apuestas).maxBy(apuestas => criterio_arriesgado(apuestas.toList)).toList
      }
      //También queremos dar la posibilidad al usuario de crear un jugador al que le pasamos un criterio para comparar distribuciones y elige según ese criterio.
      case TipoCriterio(criterio) => combinar(posibles_apuestas).maxBy(apuestas => criterio(apuestas.toList)).toList
    }
  }

  //TODO ver como sperar esto en Distribucion Equiprobable y Distribucion a Partir de eventos Ponderados
  val probabilidad: Apuesta => Double = apuesta =>{
    apuesta.tipo.tipoApuesta match{
      case Cara | Cruz => DistribucionEquiprobable.probabilidad(List(Cara,Cruz))
      case CaraCargada => DistribucionPonderada.probabilidad(List(CaraCargada,Cruz,CaraCargada,Cruz,CaraCargada,Cruz,CaraCargada), apuesta.tipo.tipoApuesta)
      case CruzCargada => DistribucionPonderada.probabilidad(List(CruzCargada,Cara,CruzCargada,Cara,CruzCargada,Cara,CruzCargada), apuesta.tipo.tipoApuesta) // deberia ser una distribucion a partir de eventos ponderados ejem [Cruz,Cara,Cruz,Cara,Cruz,Cara,Cruz]
      case Rojo | Negro | Par | Impar => 18.0/37.0 //porque el 0 no es par/impar ni negro/rojo
      case PrimerDocena | SegundaDocena | TercerDocena => 12.0/37.0
      case Numero(_) => 1.0/37.0
    }
  }

  //me da un random [0,hasta), sin incluir la posibilidad que de el valor hasta.
  def dame_un_random(menor_a: Int): Int ={
    scala.util.Random.nextInt(menor_a)
  }

  // Auxiliar para método evaluar, ayuda a obtener el resultado de la apuesta
  def sale(tipoApuesta: TipoApuesta): Boolean = {
    tipoApuesta match {
      case Cara | CaraCargada =>  dame_un_random(2) == 0
      case Cruz | CruzCargada =>  dame_un_random(2) == 1
      case Rojo => List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36).contains(dame_un_random(37))
      case Negro => List[Int](2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35).contains(dame_un_random(37))
      case Par  => dame_un_random(37) % 2 == 0
      case Impar => dame_un_random(37) % 2 == 1
      case PrimerDocena => List.range(1,13).contains(dame_un_random(37))
      case SegundaDocena => List.range(13,25).contains(dame_un_random(37))
      case TercerDocena => List.range(25,37).contains(dame_un_random(37))
      case Numero(numero) => numero == dame_un_random(37)
    }
  }

  // Dada una apuesta y un jugador evalúa si este gana la apuesta y paga el monto.
  def evaluar(apuesta:Apuesta, resultado: State): State={
    if (sale(apuesta.tipo.tipoApuesta)) {
      resultado.gana(apuesta.monto * 1 / probabilidad(apuesta))
    } else{
      resultado
    }
  }

  // states


  def jugar(apuestas: Apuestas, jugador: Jugador): State ={
    apuestas.foldLeft(State(jugador)){
      (resultado_previo, apuesta) =>
        resultado_previo match{
          case Betting(jugador) => if(jugador.puedePagar(apuesta)) resultado_previo.hacerApuesta(apuesta) else {
            println(s"[${jugador.nombre}] no puede pagar ${apuesta.monto} porque solo tiene ${jugador.monto}")
            StandBy(jugador)
          }
          case StandBy(jugador) => jugar(apuestas.tail,jugador)
        }
    }
}


}
