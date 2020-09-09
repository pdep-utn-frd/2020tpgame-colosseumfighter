import wollok.game.*
import pj.*
import armas.*
import tableros.*

//-----------------------------------------------------Level-Up------------------------------------------------------------//
object inicioLevelUp {

	method iniciar() {
		game.cellSize(100)
		game.addVisual(levelG)
		self.start()
		self.configurateLevelUp()
	}

	method configurateLevelUp() {
		keyboard.enter().onPressDo{ punteroLvlUp.objetoSeleccionado().act()} // hace actual el boton seleccionado
		keyboard.down().onPressDo{ if (punteroLvlUp.position() == game.at(15, 7)) punteroLvlUp.position(punteroLvlUp.position().down(1))
		}
		keyboard.up().onPressDo{ if (punteroLvlUp.position() == game.at(15, 6)) punteroLvlUp.position(punteroLvlUp.position().up(1))
		}
		keyboard.left().onPressDo{ if (punteroLvlUp.position() == game.at(15, 5)) punteroLvlUp.position(punteroLvlUp.position().left(5))
		}
		keyboard.right().onPressDo{ if (punteroLvlUp.position() == game.at(10, 5)) punteroLvlUp.position(punteroLvlUp.position().right(5))
		}
			// ayudas para testear
		keyboard.h().onPressDo{ game.say(punteroLvlUp, prota.fuerza().toString())}
		keyboard.j().onPressDo{ game.say(punteroLvlUp, prota.agilidad().toString())}
	}

	method clean() {
		game.removeVisual(fuerzaUp)
		game.removeVisual(agilidadUp)
		game.removeVisual(punteroLvlUp)
	}

	method start() {
		punteroLvlUp.position(game.at(15, 7))
		game.addVisual(fuerzaUp)
		game.addVisual(agilidadUp)
		game.addVisual(punteroLvlUp)
	}

	method xpTest() {
		punteroLvlUp.times(punteroLvlUp.times() + 1)
		if (punteroLvlUp.times() == 3) {
			game.removeVisual(fuerzaUp)
			game.removeVisual(agilidadUp)
			punteroLvlUp.position(enter.position())
			game.addVisual(enter)
			game.addVisual(restart)
		}
	}

}

object fuerzaUp {

	var property image = "Pointer.png"
	var property position = game.at(15, 7)
	var property es = "boton"
	var property times = 0

	method act() {
		self.times(self.times() + 1)
		inicioLevelUp.xpTest()
	}

}

object agilidadUp {

	var property image = "Pointer.png"
	var property position = game.at(15, 6)
	var property es = "boton"
	var property times = 0

	method act() {
		self.times(self.times() + 1)
		inicioLevelUp.xpTest()
	}

}

object enter {

	var property image = "Checkmark.png"
	var property position = game.at(15, 5)
	var property es = "boton"

	method act() {
		prota.fuerza(prota.fuerza() + fuerzaUp.times())
		prota.agilidad(prota.agilidad() + agilidadUp.times())
		fuerzaUp.times(0)
		agilidadUp.times(0)
		punteroLvlUp.times(0)
		inicioLobby.inicio()
	}

}

object restart {

	var property image = "Reload.png"
	var property position = game.at(10, 5)
	var property es = "boton"

	method act() {
		fuerzaUp.times(0)
		agilidadUp.times(0)
		punteroLvlUp.times(0)
		game.removeVisual(self)
		game.removeVisual(enter)
		punteroLvlUp.position(game.at(15, 7))
		game.addVisual(fuerzaUp)
		game.addVisual(agilidadUp)
	}

}

object punteroLvlUp {

	var property image = "cuadrado.png"
	var property position = game.at(15, 7)
	var property times = 0

	method objetoSeleccionado() {
		return game.colliders(self).find({ elem => elem.es() == "boton" })
	}

}

object levelG {

	var property position = game.at(9, 4)
	var property image = "levlUpGround.png"

}

//-----------------------------------------------------Tienda--------------------------------------------------------------// 
object inicioTienda {

	method iniciar() {
		self.start()
		self.configurateTienda()
	}

	method configurateTienda() {
		keyboard.enter().onPressDo{ punteroTienda.objetoSeleccionado().act()}
	}

	method start() {
		punteroTienda.position(game.at(2, 12))
		game.addVisual(tiendaG)
		game.addVisual(cartelT)
		game.addVisual(punteroTienda)
		game.addVisual(reload)
		game.addVisual(checkmark)
	}

}

object reload {

	var property image = "cruz.png"
	var property position = game.at(10, 12)
	var property es = "boton"

	method act() {
		game.removeVisual(tiendaG)
		game.removeVisual(cartelT)
		game.removeVisual(punteroTienda)
		game.removeVisual(self)
		game.removeVisual(checkmark)
		inicioLobby.inicio()
	}

}

object checkmark {

	var property image = "Checkmark.png"
	var property position = game.at(2, 12)
	var property es = "boton"

	method act() {
		prota.mejorarArma()
		punteroTienda.position(game.at(10, 12))
	}

}

object punteroTienda {

	var property image = "cuadrado.png"
	var property position = game.at(2, 12)

	method objetoSeleccionado() {
		return game.colliders(self).find({ elem => elem.es() == "boton" })
	}

}

object cartelT {

	var property image = "cartel.png"
	var property position = game.at(0, 10)
	var property es = "cartel"

}

object tiendaG {

	var property image = "tiendaG.png"
	var property position = game.at(0, 0)

}

//------------------------------------------------------Pelea--------------------------------------------------------------//
object inicioPelea {

	method configurarPelea() {
		// CONFIGURACI�N DEL JUEGO
		game.clear()
		game.addVisual(fightG)
		game.ground("celda.png")
		game.cellSize(50)
		prota.stamina(prota.staminaMax())
			// nuevo enemigo "aleatorio"
		creator.newEnem()
		creator.asign()
			// Visuales	
		enemigo1.inicializar()
		game.addVisual(prota)
		prota.iniciarBarra()
		game.addVisual(enemigo1)
		enemigo1.iniciarBarra()
		turno.turnoDe("prota")
		turno.turnoProta()
	}

}

object turno {

	var property turnoDe
	var property atacando = false

	method turnoProta() {
		var runPer
		var haveTry = true
		game.say(prota, "mi turno")
		keyboard.u().onPressDo{ runPer = 0.randomUpTo(100).roundUp()
			if ((runPer < 70) and (haveTry)) {
				inicioLobby.inicio()
				haveTry = true
			} else game.say(prota, ("miss"))
			haveTry = false
		}
		keyboard.p().onPressDo{ if ((prota.stamina() >= 20) and (self.turnoDe() == "prota") and not atacando) {
				atacando = true
				prota.pelear(enemigo1)
				prota.stamina(prota.stamina() - 20)
					// --------Actualizacion de stamina------------------------------------------------------------//			
				game.removeVisual(barraStaminaProta)
				barraStaminaProta.cuantaStamina()
				numberConverterStamina.getNumberImage(barraStaminaProta.number().max(0).toString(), barraStaminaProta)
				game.addVisual(barraStaminaProta)
					// -------------------------------------------------------------------------------------------//
				if (enemigo1.vida() <= 0) {
					game.onTick(4100, "Ganar", {=>
						game.say(prota, "gane")
						prota.monedas(prota.monedas() + 4)
						prota.earnXp()
					})
				}
				game.say(prota, prota.stamina().toString())
			}
		}
		keyboard.o().onPressDo{ if (self.turnoDe() == "prota") {
				prota.defender()
				haveTry = true
				self.turnoDe("enemigo")
				self.turnoEnem()
			}
		}
		keyboard.i().onPressDo{ if (self.turnoDe() == "prota") {
				prota.stamina(prota.staminaMax())
				haveTry = true
				enemigo1.resistencia(0)
					// --------Actualizacion de stamina------------------------------------------------------------//			
				game.removeVisual(barraStaminaProta)
				barraStaminaProta.cuantaStamina()
				numberConverterStamina.getNumberImage(barraStaminaProta.number().max(0).toString(), barraStaminaProta)
				game.addVisual(barraStaminaProta)
					// -------------------------------------------------------------------------------------------//
				self.turnoDe("enemigo")
				self.turnoEnem()
			}
		}
	}

	method turnoEnem() {
		var defPer
		game.say(enemigo1, "mi turno")
		if ((enemigo1.stamina() >= 20) and (self.turnoDe() == "enemigo") and not atacando) {
			enemigo1.stamina(enemigo1.stamina() - 20)
				// --------Actualizacion de stamina------------------------------------------------------------//			
			game.removeVisual(barraStaminaE1)
			barraStaminaE1.cuantaStamina()
			numberConverterStamina.getNumberImage(barraStaminaE1.number().max(0).toString(), barraStaminaE1)
			game.addVisual(barraStaminaE1)
				// -------------------------------------------------------------------------------------------// 	
			game.onTick(4100, "enemAttack", {=>
				(if (enemigo1.vida() > 0) {
					enemigo1.pelear()
					if (prota.vida() <= 0) {
						game.onTick(4100, "perder", {=>
							game.say(enemigo1, "perdiste")
							gameOver.muerte()
						})
					}
				} else {
					game.say(prota, "gane")
					inicioLevelUp.iniciar()
				} )
				game.removeTickEvent("enemAttack")
				game.onTick(4100, "reTurno", {=>
					self.turnoEnem()
					game.removeTickEvent("reTurno")
				})
			})
		} else {
			defPer = 0.randomUpTo(100).roundUp()
			if (defPer > 50) {
				enemigo1.defender()
				game.onTick(4100, "cambioTurno", {=>
					self.turnoDe("prota")
					game.say(prota, "mi turno")
					game.removeTickEvent("cambioTurno")
				})
			} else {
				enemigo1.stamina(enemigo1.staminaMax())
					// --------Actualizacion de stamina------------------------------------------------------------//			
				game.removeVisual(barraStaminaE1)
				barraStaminaE1.cuantaStamina()
				numberConverterStamina.getNumberImage(barraStaminaE1.number().max(0).toString(), barraStaminaE1)
				game.addVisual(barraStaminaE1)
					// -------------------------------------------------------------------------------------------//
				prota.resistencia(0)
				game.onTick(4100, "cambioTurno", {=>
					self.turnoDe("prota")
					game.say(prota, "mi turno")
					game.removeTickEvent("cambioTurno")
				})
			}
		}
	}

}

object fightG {

	var property position = game.at(0, 0)

	method image() = "fondo1.png"

}

