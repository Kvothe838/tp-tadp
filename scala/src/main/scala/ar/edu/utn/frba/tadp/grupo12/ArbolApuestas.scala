package ar.edu.utn.frba.tadp.grupo12

import scala.annotation.tailrec

trait ArbolApuestas[+A]{
  def contar_hojas: Int ={
    @tailrec
    def loop(t: List[ArbolApuestas[A]], z: Int): Int = t match {
      case (l: HojaApuesta[A]) :: tl => loop(tl, z + 1)
      case (n: RamaApuestas[A]) :: tl => loop(n.izq :: n.der :: tl, z)
      case _ :: tl            => loop(tl, z)
      case _                  => z
    }
    loop(List(this),  0)
  }
  def altura: Int = {
    def loop(t: ArbolApuestas[A]): Int = t match {
      case l: HojaApuesta[A] => 1
      case n: RamaApuestas[A] => Seq(loop(n.izq), loop(n.der)).max + 1
      case _          => 0
    }
    loop(this) - 1
  }
}
case class HojaApuesta[A](value: A) extends ArbolApuestas[A]
case class RamaApuestas[A](izq: ArbolApuestas[A], der: ArbolApuestas[A]) extends ArbolApuestas[A]

