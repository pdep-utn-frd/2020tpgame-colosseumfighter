import wollok.game.*
import pj.*
import menuCompra.*

object principal {

	const anchoTotal = 38
	const altoTotal = 20

	method inicio() {
		game.clear()
		game.title("Colosseum Fighter")
		game.width(anchoTotal)
		game.height(altoTotal)
		game.ground("Celda.png")
		game.addVisual(fInicio)
		game.boardGround("fInicio.png")
		fInicio.teclas()
	}

}

object inicioLobby {

	var property iniciando = true

	method inicio() {
		if (iniciando) {
			game.removeVisual(fInicio)
			self.iniciando(false)
		}
		game.boardGround("fLobby.png")
		fLobby.teclas()
	}

}

object gameOver {

	method muerte() {
		game.removeTickEvent("perder")
		game.clear()
		game.boardGround("deadG.png")
		keyboard.r().onPressDo{ prota.respawn()
			principal.inicio()
		}
		keyboard.q().onPressDo{ game.stop()}
	}

}


object fLobby {

	method teclas() {
		game.clear()
		keyboard.s().onPressDo{ inicioPelea.configurarPelea()}
		keyboard.d().onPressDo{ inicioTienda.iniciar()
			game.removeVisual(self)
		}
	}

}

object fInicio {

	method teclas() {
		var iniciado = 0
		keyboard.enter().onPressDo{ if (iniciado == 0) inicioLobby.inicio()
			iniciado = 1
		}
		keyboard.q().onPressDo{ game.stop()}
	}

}

