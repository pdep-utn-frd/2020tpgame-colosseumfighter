import wollok.game.*
import Animation2.*
import pantallas.*
import fondos.*

//--------------------------------------------------Armas----------------------------------------------------------//

class Arma {
	var property danio = 10
	const property peso = 2
}

const espada = new Arma (danio = 17, peso = 2)
const manos= new Arma (danio = 5, peso= 0)
const lanza = new Arma(danio = 15, peso =1.5)

//--------------------------------------------------visuales-vida----------------------------------------------------------//
class BarraVida {

	var property image = "hp bar 50 of 50.png"
	var property number = 100
	var property position = game.at(2, 2)
	const property persona

	method cuanta() {
		number = 50 - (persona.vida().div(2).roundUp())
	}

	method position() {
		position = persona.position().right(3).up(1)
		return position
	}

}

const barraVidaProta = new BarraVida(persona = prota)

const barraVidaE1 = new BarraVida(persona = enemigo1)

//--------------------------------------------------visuales-stamina----------------------------------------------------------//
class BarraStamina {

	var property image = "stamina-bar-50-of-50.png"
	var property number = 50
	var property position = game.at(2, 2)
	const property persona

	method porcentaje() {
		return (persona.stamina() * 100 / persona.staminaMax()).roundUp(0)
	}

	method cuanta() {
		number = 50 - (self.porcentaje() / 2)
	}

	method position() {
		position = persona.position().right(3)
		return position
	}
}

const barraStaminaProta = new BarraStamina(persona = prota)

const barraStaminaE1 = new BarraStamina(persona = enemigo1)

//------------------------------------------------------------------------------------------------------------------------//
object prota {

	var property arma = espada
	var property monedas = 12
	var property stamina = 40
	var property peso = 54
	var property staminaMax = 40
	var property vida = 100
	var property resistencia = 0
	var property fuerza = 5
	var property agilidad = 3
	var danio = 0
	var property xp = 0
	var property nextLvlAt = 40
	var property contrincante
	var property position = game.at(2, 2)
	var property barName = barraVidaProta
	var property barStaminaName = barraStaminaProta
	// Image converter 	
	var property image = "Satyr_01_Attacking_0.png"
	var property clave = "Satyr"
	var property num = "01"


	method earnXp() {
		self.xp(self.xp() + 40)
		if (self.xp() >= self.nextLvlAt()) {
			self.xp(self.xp() - self.nextLvlAt())
			self.nextLvlAt(self.nextLvlAt() * 2)
			inicioLevelUp.iniciar()
		} else {
			inicioLobby.inicio()
		}
	}

	method respawn() {
		self.nextLvlAt(40)
		self.fuerza(5)
		self.agilidad(3)
		self.xp(0)
		self.stamina(30)
		self.staminaMax(30)
		self.monedas(6)
		self.arma(espada)
		self.vida(100)
	}

	method recibirDanio(damage) {
		vida = vida - ((damage - (damage * 0.01 * (self.agilidad() + self.resistencia())))).roundUp(0)
		if (self.vida() < 0) self.vida(0)
		actualizador.actualizarVida(barName)
	}

	method pelear(enemigo) {
		var atPer // porcentaje de ataque
		self.contrincante(enemigo)
		self.stamina(self.stamina() - 20)
		actualizador.actualizarStamina(barraStaminaProta)
		
		atPer = 0.randomUpTo(100).roundUp()
		if ((atPer) > (30 + peso ** (1 / 2))) {
			danio = (arma.danio() + self.fuerza()).roundUp()
			enemigo.recibirDanio(danio)
			enemigo.position(game.at(24, 2))
			accionConjDer.accion()
			game.schedule(3800, {=>turno.atacando(false)})		
		} else {
			accionConjDer.accion()
			game.schedule(3800, {=>turno.atacando(false)})
			game.say(enemigo, "miss")

		}
	}

	method defender() {
		self.stamina(self.stamina() + self.staminaMax() / 2)		
		actualizador.actualizarStamina(barStaminaName)
		self.resistencia(self.resistencia() + 30)
		enemigo1.resistencia(0)
	}

}

//------------------------------------------------------------------------------------------------------------------------//
object enemigo1 {

	var property arma = espada
	var property vida = 100
	var property stamina = 40
	var property staminaMax = 40
	var property resistencia = 0
	const property fuerza = 5
	const property agilidad = 3
	var danio = 0
	var property position = game.at(24, 2)
	const peso = 67
	const property enemigo = prota
	var property clave = "Satyr"
	var property num = "02"
	var property image = "Satyr_02_Attacking_0.png"
	const property barName = barraVidaE1
	const property barStaminaName = barraStaminaE1

	method recibirDanio(damage) {
		vida = vida - ((damage - (damage * 0.01 * (self.agilidad() + self.resistencia())))).roundUp(0)
		if (self.vida() < 0) self.vida(0)
		actualizador.actualizarVida(barName)
	}

	method inicializar() {
		imageConverter.getNumberImage(self, self.num(), "Walking", 17)
		self.vida(100)
	}

	method pelear() {
		var atPer // porcentaje de ataque
		atPer = 0.randomUpTo(100).roundUp()
		self.stamina(self.stamina() - 20)
		actualizador.actualizarStamina(barStaminaName)
		
		if ((atPer) > (30 + peso ** (1 / 2))) {
			danio = (arma.danio() + self.fuerza()).roundUp()
			enemigo.recibirDanio(danio)
			prota.position(game.at(2, 2))
			accionConjizq.accion()
			game.schedule(4100, {=>turno.atacando(false)})
			actualizador.actualizarVida(barraVidaProta)
		} 
		else {
			accionConjizq.accion()
			game.schedule(4100, {=>turno.atacando(false)})
			game.say(enemigo, "miss")
		}
		if (enemigo.vida() < 0) game.say(self, "I win")
	}

	method defender() {
		self.stamina(self.stamina() + self.staminaMax() / 2)		
		actualizador.actualizarStamina(barStaminaName)
		self.resistencia(self.resistencia() + 30)
		enemigo.resistencia(0)
	}

}
//-----------------------------------------------------------------------------------------------------------------------//
object creator {

	var property clave
	var property num
	var property arma

	method newEnem() {
		self.clave([ "Golem", "Ogre" ].anyOne())
		self.num([ "02", "03" ].anyOne())
		self.arma([ espada, lanza, manos ].anyOne())
	}

	method asign() {
		enemigo1.arma(self.arma())
		enemigo1.clave(self.clave())
		enemigo1.num(self.num())
	}

}


//------------------------------------------------------------------------------------------------------------------------//
object imageConverter {

	method getNumberImage(pj, num, accion, time) {
		pj.image(pj.clave() + "_" + num + "_" + accion + "_" + time + ".png")
	}

}

object numberConverter {

	method getNumberImage(number, barraVida) {
		barraVida.image("hp bar " + number + " of 50.png")
	}

}

object numberConverterStamina {

	method getNumberImage(number, barraStamina) {
		barraStamina.image("stamina-bar-" + number + "-of-50.png")
	}

}

object actualizador {
	method actualizarVida(barra){
		game.removeVisual(barra)
		barra.cuanta()
		numberConverter.getNumberImage(barra.number().max(0).toString(), barra)
		game.addVisual(barra)
	}
	
	method actualizarStamina(barra){
		game.removeVisual(barra)
		barra.cuanta()
		numberConverterStamina.getNumberImage(barra.number().max(0).toString(), barra)
		game.addVisual(barra)
	}

	
}
//------------------------------------------------------------------------------------------------------------------------//
