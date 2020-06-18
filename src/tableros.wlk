
import wollok.game.*
import pj.*
import menuCompra.*

object principal{
	const anchoTotal = 38
	const altoTotal = 20
//	const anchoRecuadro = 22 
//	const altoRecuadro = 11
	method inicio(){
		game.clear()
		game.title("Colosseum Fighter")
		game.width(anchoTotal)
		game.height(altoTotal)
		game.ground("Celda.png")
		game.addVisual(fInicio)
		fInicio.teclas()
		}
	}


object inicioLobby{
	var property iniciando = true
	method inicio(){
		if (iniciando) {game.removeVisual(fInicio)  self.iniciando(false)}
		game.addVisual(fLobby)
		fLobby.teclas()
		
	}
}

object gameOver{
	method muerte(){
		game.removeTickEvent("perder")	
		game.addVisual(deadG)
		keyboard.r().onPressDo{prota.respawn() principal.inicio()}
		keyboard.q().onPressDo{game.stop()}
	}
}
object deadG{
	var property position = game.at(0,0)
	method image()="deadG.png"
}


object fLobby{
	var property position = game.at(0,0)
	method image()="fondo1.png"
	method teclas(){
		keyboard.s().onPressDo{inicioPelea.configurarPelea()}
		keyboard.d().onPressDo{inicioTienda.iniciar()game.removeVisual(fLobby)}
//		keyboard.f().onPressDo{inicioSeleccion.iniciar()game.removeVisual(fLobby)}
	}
	
}

object fInicio{
	var property position = game.at(0,0)
	method image()="fInicio.png"
	method teclas(){
		var iniciado = 0
		keyboard.enter().onPressDo{if(iniciado == 0 )inicioLobby.inicio() iniciado = 1}
		keyboard.q().onPressDo{game.stop()}
		}	
}
