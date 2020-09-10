import wollok.game.*
import armas.*
import Animation2.*
import menuCompra.*
import tableros.*

//--------------------------------------------------visuales-vida----------------------------------------------------------//
class BarraVida {

	var property image = "hp bar 50 of 50.png"
	var property number = 100
	var property position = game.at(2, 2)
	const property persona

	method cuantaVida() {
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

	method cuantaStamina() {
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
	var property peso = 65
	var property stamina = 30
	var property staminaMax = 30
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

	method mejorarArma() {
		if (monedas >= 10) {
			espada.danio(espada.danio() + 6)
			game.say(checkmark, "compraste")
			self.monedas(self.monedas() - 10)
		} else punteroTienda.position(game.at(10, 12))
	}

	method earnXp() {
		self.xp(self.xp() + 40)
		if (self.xp() >= self.nextLvlAt()) {
			self.xp(self.xp() - self.nextLvlAt())
			self.nextLvlAt(self.nextLvlAt() * 2)
			game.removeTickEvent("Ganar")
			inicioLevelUp.iniciar()
		} else {
			game.removeTickEvent("Ganar")
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
	}

	method iniciarBarra() {
		barName.cuantaVida()
		barName.position(self)
		numberConverter.getNumberImage(barName.number().toString(), barName)
		game.addVisual(barName)
		barStaminaName.cuantaStamina()
		barStaminaName.position(self)
		numberConverterStamina.getNumberImage(barStaminaName.number().max(0).toString(), barStaminaName)
		game.addVisual(barStaminaName)
	}

	method pelear(enemigo) {
		var atPer // porcentaje de ataque
		self.contrincante(enemigo)
		atPer = 0.randomUpTo(100).roundUp()
		if ((atPer) > (30 + peso ** (1 / 2))) {
			danio = (arma.danio() + self.fuerza()).roundUp()
			enemigo.recibirDanio(danio)
			enemigo.position(game.at(24, 2))
			accionConjDer.accion()
			game.onTick(4100, "restriccion de ataque", {=>
				turno.atacando(false)
				game.removeTickEvent("restriccion de ataque")
			})
//-------------------------------------Actualizacion de barra de vida-----------------------------------------------------//			
			game.removeVisual(barraVidaE1)
			barraVidaE1.cuantaVida()
			numberConverter.getNumberImage(barraVidaE1.number().max(0).toString(), barraVidaE1)
			game.addVisual(barraVidaE1)
//------------------------------------------------------------------------------------------------------------------------//
		} else {
			accionConjDer.accion()
			game.onTick(4100, "restriccion de ataque", {=>
				turno.atacando(false)
				game.removeTickEvent("restriccion de ataque")
			})
			danio = 0
			game.say(enemigo, "miss")
			enemigo.recibirDanio(danio)
		}
	}

	method defender() {
		self.stamina(self.stamina() + self.staminaMax() / 2)
			// --------Actualizacion de stamina------------------------------------------------------------//			
		game.removeVisual(barraStaminaProta)
		barraStaminaProta.cuantaStamina()
		numberConverterStamina.getNumberImage(barraStaminaProta.number().max(0).toString(), barraStaminaProta)
		game.addVisual(barraStaminaProta)
			// -------------------------------------------------------------------------------------------//
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
	}

	method iniciarBarra() {
		barName.cuantaVida()
		barName.position(self)
		numberConverter.getNumberImage(barName.number().toString(), barName)
		game.addVisual(barName)
		barStaminaName.cuantaStamina()
		barStaminaName.position(self)
		numberConverterStamina.getNumberImage(barStaminaName.number().max(0).toString(), barStaminaName)
		game.addVisual(barStaminaName)
	}

	method inicializar() {
		imageConverter.getNumberImage(self, self.num(), "Walking", 17)
		self.vida(100)
	}

	method pelear() {
		var atPer // porcentaje de ataque
		atPer = 0.randomUpTo(100).roundUp()
		if ((atPer) > (30 + peso ** (1 / 2))) {
			danio = (arma.danio() + self.fuerza()).roundUp()
			enemigo.recibirDanio(danio)
			prota.position(game.at(2, 2))
			accionConjizq.accion()
			game.onTick(4100, "restriccion de ataque", {=>
				turno.atacando(false)
				game.removeTickEvent("restriccion de ataque")
			})
//-------------------------------------actualizacion de barra de vida-----------------------------------------------------//			
			game.removeVisual(barraVidaProta)
			barraVidaProta.cuantaVida()
			numberConverter.getNumberImage(barraVidaProta.number().max(0).toString(), barraVidaProta)
			game.addVisual(barraVidaProta)
		} //------------------------------------------------------------------------------------------------------------------------//
		else {
			accionConjizq.accion()
			game.onTick(4100, "restriccion de ataque", {=>
				turno.atacando(false)
				game.removeTickEvent("restriccion de ataque")
			})
			danio = 0
			game.say(enemigo, "miss")
			enemigo.recibirDanio(danio)
		}
		if (enemigo.vida() < 0) game.say(self, "gane")
	}

	method defender() {
		self.stamina(self.stamina() + self.staminaMax() / 2)
			// --------Actualizacion de stamina------------------------------------------------------------//			
		game.removeVisual(barStaminaName)
		barraStaminaE1.cuantaStamina()
		numberConverterStamina.getNumberImage(barStaminaName.number().max(0).toString(), barStaminaName)
		game.addVisual(barraStaminaE1)
			// -------------------------------------------------------------------------------------------//
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

