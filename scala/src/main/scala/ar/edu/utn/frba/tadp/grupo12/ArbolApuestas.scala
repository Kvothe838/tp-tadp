package ar.edu.utn.frba.tadp.grupo12

import scala.annotation.tailrec

trait ArbolApuestas[+A]{
  def contar_hojas: Int ={
    @tailrec
    def loop(a: List[ArbolApuestas[A]], z: Int): Int = a match {
      case (hoja: HojaApuesta[A]) :: cola => loop(cola, z + 1)
      case (rama: RamaApuestas[A]) :: cola => loop(rama.izq :: rama.der :: cola, z)
      case _ :: cola            => loop(cola, z)
      case _                  => z
    }
    loop(List(this),  0)
  }
  def altura: Int = {
    def loop(arbol: ArbolApuestas[A]): Int = arbol match {
      case hoja: HojaApuesta[A] => 1
      case rama: RamaApuestas[A] => Seq(loop(rama.izq), loop(rama.der)).max + 1
      case _          => 0
    }
    loop(this) - 1
  }
}
case class HojaApuesta[A](value: A) extends ArbolApuestas[A]
case class RamaApuestas[A](izq: ArbolApuestas[A], der: ArbolApuestas[A]) extends ArbolApuestas[A]

