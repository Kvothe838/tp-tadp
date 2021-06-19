package ar.edu.utn.frba.tadp.grupo12

object Casino {
  type Abc = Jugador => Jugador
  type Apuestas = List[Apuesta]

  //No estoy seguro que que voy a hacer con esto, podria devolver Apuestas.
  def planificar(jugador:Jugador){
    val posibles_apuestas: List[TipoApuesta] = List(Cara,Cruz,CaraCargada,CruzCargada,Negro,Rojo,Par,Impar,PrimerDocena,SegundaDocena,TercerDocena,new Numero(1))
    jugador.tipo match {
      case TipoCauto => {
        ???
      }
      case TipoRacional => {
        ???
      }
      case TipoArriesgado => {
        ???
      }
      case TipoCriterio(criterio) => criterio(posibles_apuestas)
    }
  }

  //devuelve la probabilidad de cada tipo de apuesta
  val probabilidad: (Apuesta => Double) = apuesta =>{
    apuesta.tipo match{
      case Cara | Cruz => 1.0/2.0
      case CaraCargada | CruzCargada => 4/7
      case Rojo | Negro | Par | Impar => 18.0/37.0 //porque el 0 no es par/impar ni negro/rojo
      case PrimerDocena | SegundaDocena | TercerDocena => 12.0/37.0
      case Numero(_) => 1.0/37.0
    }
  }

  //me da un random [0,hasta), osea sin incluir la posibilidad de que el hasta.
  def dame_un_random(hasta: Int): Int ={
    scala.util.Random.nextInt(hasta)
  }

  // Auxiliar para metodo evaluar, ayuda a obtener el resultado de la apuesta
  def sale(tipoApuesta: TipoApuesta): Boolean = {
    tipoApuesta match {
      case Cara | CaraCargada =>  (dame_un_random(1) == 0)
      case Cruz | CruzCargada =>  (dame_un_random(1) == 1)
      case Rojo => List[Int](1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36).contains(dame_un_random(37))
      case Negro => List[Int](2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35).contains(dame_un_random(37))
      case Par  => (dame_un_random(37) % 2 == 0)
      case Impar => (dame_un_random(37) % 2 == 1)
      case PrimerDocena => List.range(1,13).contains(dame_un_random(37))
      case SegundaDocena => List.range(13,25).contains(dame_un_random(37))
      case TercerDocena => List.range(25,37).contains(dame_un_random(37))
      case Numero(numero) => numero == dame_un_random(37)
    }
  }
  // Dada una apuesta y un jugador evalua si este gana la apuesta y paga el monto.
  def evaluar(apuesta:Apuesta, jugador:Jugador): Jugador={
    println(s"[${jugador.nombre}]: Antes de apostar:${jugador.monto}")
    if (sale(apuesta.tipo)) jugador.gana(apuesta.monto * 1 / probabilidad(apuesta))
    println(s"[${jugador.nombre}]: Despues de apostar:${jugador.monto}")
    jugador
  }

  def jugar(apuestas: Apuestas, jugador:Jugador) ={
    for(apuesta <- apuestas) {
      println(s"[${jugador.nombre}]: dinero:${jugador.monto} cantidad apostando:${apuesta.monto}")
      //Si puede y paga la apuesta entonces se evalua la apuesta para ver si gana, sino se sigue a la siguiente apuesta
      if (jugador.pagar(apuesta)) evaluar(apuesta, jugador)
    }
  }
}