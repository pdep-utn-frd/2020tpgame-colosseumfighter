import wollok.game.*
import objetos.*
import fondos.*

//-----------------------------------------------------Level-Up------------------------------------------------------------//
object inicioLevelUp {

	method iniciar() {
		game.clear()
		game.cellSize(100)
		game.boardGround("fondo1.png")
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
		game.clear()
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
		inicioLevelUp.iniciar()
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
object tiendaG {

	var property image = "tiendaG.png"
	var property position = game.at(0, 0)

}

object tienda{
	method mejorarArma() {
		if (prota.monedas() >= 10) {
			espada.danio(espada.danio() + 6)
			game.say(checkmark, "Upgraded")
			prota.monedas(prota.monedas() - 10)
		} else{
			 game.say(checkmark, "Not enough money")
			 }
	}
}

object inicioTienda {

	method iniciar() {
		game.clear()
		self.configurateTienda()
		self.start()
	}

	method configurateTienda() {
		keyboard.enter().onPressDo{ punteroTienda.objetoSeleccionado().act()}
	}

	method start() {
		game.addVisual(tiendaG)
		punteroTienda.position(game.at(2, 12))
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
		game.removeVisual(cartelT)
		game.removeVisual(punteroTienda)
		game.removeVisual(checkmark)
		game.removeVisual(self)		
		inicioLobby.inicio()
	}

}

object checkmark {

	var property image = "Checkmark.png"
	var property position = game.at(2, 12)
	var property es = "boton"

	method act() {
		tienda.mejorarArma()
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


//------------------------------------------------------Pelea--------------------------------------------------------------//
object fightG {

	var property position = game.at(0, 0)

	method image() = "fondo1.png"

}
object inicioPelea {

	method iniciarBarra(char){
		(char.barName()).cuanta()
		(char.barName()).position(char.position())
		numberConverter.getNumberImage((char.barName()).number().toString(), (char.barName()))
		game.addVisual((char.barName()))
		(char.barStaminaName()).cuanta()
		(char.barStaminaName()).position(char.position())
		numberConverterStamina.getNumberImage((char.barStaminaName()).number().max(0).toString(), (char.barStaminaName()))
		game.addVisual((char.barStaminaName()))
	}
	
	method configurarPelea() {
		// CONFIGURACI�N DEL JUEGO
		game.clear()
		game.addVisual(fightG)
		game.cellSize(50)
		prota.stamina(prota.staminaMax())
		// nuevo enemigo "aleatorio"
		creator.newEnem()
		creator.asign()
		// Visuales	
		enemigo1.inicializar()
		prota.position(game.at(2, 2))
		game.addVisual(prota)
		self.iniciarBarra(prota)
		game.addVisual(enemigo1)
		self.iniciarBarra(enemigo1)
		turno.turnoDe(prota)
		turno.turnoProta()
	}

}


object turno {

	var property turnoDe
	var property atacando = false

	method esTurnoDe(char){
		return (self.turnoDe() == char)
	}
	
	method puedeAtacar(char) {
		return ((char.stamina() >= 20) and (self.esTurnoDe(char)) and (char.vida() > 0))	
	}
	
	method defenderse(char, enem) {
		char.stamina(char.stamina() + char.staminaMax() / 2)		
		actualizador.actualizarStamina(char.barStaminaName())
		char.resistencia(char.resistencia() + 30)
		enem.resistencia(0)
	}
	
	method recibirDanio(damage, char) {
		char.vida(char.vida() - ((damage - (damage * 0.01 * (char.agilidad() + char.resistencia())))).roundUp(0))
		if (char.vida() < 0) char.vida(0)
		game.schedule(1500, {=>actualizador.actualizarVida(char.barName())})
		}
	
	
	method turnoProta() {
		var runPer
		var haveTry = true
		game.say(prota, "my turn")
		// intento de escape
		keyboard.u().onPressDo{ runPer = 0.randomUpTo(100).roundUp()
			if ((runPer < 70) and (haveTry)) {
				inicioLobby.inicio()
			} else game.say(prota, ("miss"))
			haveTry = false
		}
		// atacar
		keyboard.p().onPressDo{ if (self.puedeAtacar(prota) and not atacando) {
				atacando = true
				(prota.enemigo()).position(game.at(24, 2))
				prota.pelear()
				game.schedule(1500, {=> if ((prota.enemigo()).vida() == 0) {
					game.schedule(4100,{=>  game.say(prota, "I Win")
											prota.monedas(prota.monedas() + 4)
											prota.earnXp() })
				}})
			}
		}
		keyboard.o().onPressDo{ if (self.esTurnoDe(prota)) {
				self.defenderse(prota, enemigo1)
				haveTry = true
				self.turnoDe(prota.enemigo())
				self.turnoEnem()
			}
		}
		keyboard.i().onPressDo{ if (self.esTurnoDe(prota)) {
				prota.stamina(prota.staminaMax())
				haveTry = true
				enemigo1.resistencia(0)
				actualizador.actualizarStamina(prota.barStaminaName())
				self.turnoDe(prota.enemigo())
				self.turnoEnem()
			}
		}
	}

	method turnoEnem() {
		var defPer
		prota.position(game.at(2, 2))
		if (self.puedeAtacar(enemigo1)){
			game.schedule(4100,{=>
					enemigo1.pelear()
					game.schedule(1500, {=> if (prota.vida() == 0) {game.schedule(4100,{=> gameOver.muerte()})} })
					game.schedule(4100,{=> self.turnoEnem()}) })}
		else {	defPer = 0.randomUpTo(100).roundUp()
				if (defPer > 50) {
					self.defenderse(enemigo1, prota)
					game.schedule(4100,{=> self.turnoDe(enemigo1.enemigo()) game.say(enemigo1.enemigo(), "my turn") })
				}
			 	else {
					enemigo1.stamina(enemigo1.staminaMax())
					actualizador.actualizarStamina(enemigo1.barStaminaName())
					prota.resistencia(0)
					game.schedule(4100,{=> self.turnoDe(enemigo1.enemigo()) game.say(enemigo1.enemigo(), "my turn") })
				}
		}
	}
}

