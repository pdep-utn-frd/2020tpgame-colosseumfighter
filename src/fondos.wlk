import wollok.game.*
import objetos.*
import pantallas.*

object principal {

	const anchoTotal = 38
	const altoTotal = 20

	method inicio() {
		game.title("Colosseum Fighter")
		game.width(anchoTotal)
		game.height(altoTotal)
		game.boardGround("fPeleaAlt1.png")
		game.addVisual(fInicio)
		game.ground("Celda.png")
		fInicio.teclas()
	}

}

object inicioLobby {

	method inicio() {
		game.clear()
		game.addVisual(fLobby)
		fLobby.teclas()
	}

}

object gameOver {

	method muerte() {
		game.clear()
		game.addVisual(deadG)
		keyboard.r().onPressDo{ prota.respawn()
			principal.inicio()
		}
		keyboard.q().onPressDo{ game.stop()}
	}

}


object fLobby {
	
	var property position = game.at(0, 0)

	method image() = "mainScreen.png"
	
	method teclas() {
		keyboard.s().onPressDo{ inicioPelea.configurarPelea()}
		keyboard.d().onPressDo{ inicioTienda.iniciar()}
	}

}

object fInicio {
	
var property position = game.at(0, 0)

	method image() = "fInicio.png"

	
	method teclas() {
		keyboard.enter().onPressDo{inicioLobby.inicio()}
		keyboard.q().onPressDo{game.stop()}
	}

}

object deadG {

	var property position = game.at(0, 0)

	method image() = "deadG.png"

}


