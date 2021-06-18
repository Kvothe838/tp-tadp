package ar.edu.utn.frba.tadp.grupo12

object Casino {
  type Abc = Jugador => Jugador
  type Apuestas = List[Apuesta]

  //No estoy seguro que que voy a hacer con esto, podria devolver Apuestas.
  def planificar(jugador:Jugador){
    val posibles_apuestas: List[TipoApuesta] = List(Cara,Cruz,Negro,Rojo,Par)
    jugador.tipo match {
      case TipoCauto => ???
      case TipoRacional => ???
      case TipoArriesgado => ???
      case TipoCriterio(criterio) => ???
    }
  }

  //devuelve la probabilidad de cada tipo de apuesta
  val probabilidad: (Apuesta => Double) = apuesta =>{
    apuesta.tipo match{
      case Cara => 1/2
      case Cruz => 1/2
      case Rojo  => 18/37 //porque el 0 no es par/impar ni negro/rojo
      case Negro  => 18/37 //porque el 0 no es par/impar ni negro/rojo
      case Par  => 18/37 //porque el 0 no es par/impar ni negro/rojo
      case Impar => 18/37 //porque el 0 no es par/impar ni negro/rojo
      case PrimerDocena => 12/37
      case SegundaDocena => 12/37
      case TercerDocena => 12/37
      case Numero(_) => 1/37
    }
  }

  //me da un random [0,hasta), osea sin incluir la posibilidad de que el hasta.
  def dame_un_random(hasta: Int): Int ={
    scala.util.Random.nextInt(hasta)
  }

  // Auxiliar para metodo evaluar, ayuda a obtener el resultado de la apuesta
  def sale(tipoApuesta: TipoApuesta): Boolean = {
    tipoApuesta match {
      case Cara => (dame_un_random(1) == 0)
      case Cruz => (dame_un_random(1) == 1)
      case Rojo => List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36).contains(dame_un_random(37))
      case Negro => !List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36).contains(dame_un_random(37))
      case PrimerDocena => List.range(1,13).contains(dame_un_random(37))
      case SegundaDocena => List.range(13,25).contains(dame_un_random(37))
      case TercerDocena => List.range(25,37).contains(dame_un_random(37))
      case Numero(numero) => numero == dame_un_random(37)
    }
  }
  // Dada una apuesta y un jugador evalua si este gana la apuesta y paga el monto.
  def evaluar(apuesta:Apuesta, jugador:Jugador): Jugador={
    println(s"AdasdasdaD:${jugador.monto}")
    apuesta.tipo match{
      case Cara => if (sale(apuesta.tipo)) {
        jugador.gana(apuesta.monto * 1 / probabilidad(apuesta))
        println(s"la probabilidad de ${apuesta.tipo} es ${probabilidad(apuesta)}")
      }
      case Cruz => if (sale(apuesta.tipo)) jugador.gana(apuesta.monto * 1/probabilidad(apuesta))
      case Rojo => if (sale(apuesta.tipo)) jugador.gana(apuesta.monto * 1/probabilidad(apuesta))
      case PrimerDocena => if ((sale(apuesta.tipo))) jugador.gana(apuesta.monto*1/probabilidad(apuesta))
      case SegundaDocena => if ((sale(apuesta.tipo))) jugador.gana(apuesta.monto*1/probabilidad(apuesta))
      case TercerDocena => if ((sale(apuesta.tipo))) jugador.gana(apuesta.monto*1/probabilidad(apuesta))
      case Negro => if ((sale(apuesta.tipo))) jugador.gana(apuesta.monto*1/probabilidad(apuesta))
      case Numero(n) => if(sale(apuesta.tipo)) jugador.gana(apuesta.monto*1/probabilidad(apuesta))
    }
    println(s"adasdasdad:${jugador.monto}")
    jugador
  }

  def jugar(apuestas: Apuestas, jugador:Jugador) ={
    for(apuesta <- apuestas) {
      println(s"dinero:${jugador.monto} cantidad apostando:${apuesta.monto}")
      //Si puede y paga la apuesta entonces se evalua la apuesta para ver si gana, sino se sigue a la siguiente apuesta
      if (jugador.pagar(apuesta)) evaluar(apuesta, jugador)
    }
  }
}
