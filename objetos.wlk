import wollok.game.*
import Animation2.*
import pantallas.*
import fondos.*

//--------------------------------------------------Armas----------------------------------------------------------//

class Arma {
	var property danio = 10
	const property peso = 2
}

const espada = new Arma (danio = 50, peso = 2)
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

//----------------------------------------------------Personajes----------------------------------------------------------//
class Fighter{
	var property arma 
	var property vida 
	var property stamina 
	var property staminaMax 
	var property resistencia 
	var property fuerza 
	var property agilidad 
	var danio 
	var property position
	const peso 
	const property enemigo 
	var property clave 
	var property num 
	var property image 
	const property barName
	const property barStaminaName 


	method accionConjunta(){
		accionConjizq.accion()
	}
	
	method pelear() {
		var atPer // porcentaje de ataque
		atPer = 0.randomUpTo(100).roundUp()
		self.stamina(self.stamina() - 20)
		actualizador.actualizarStamina(barStaminaName)
		
		if ((atPer) > (30 + peso ** (1 / 2))) {
			self.accionConjunta()
			danio = (arma.danio() + self.fuerza()).roundUp()
			turno.recibirDanio(danio, enemigo)
			game.schedule(3800, {=>turno.atacando(false)})
		} 
		else {
			self.accionConjunta()
			game.schedule(3800, {=>turno.atacando(false)})
			game.say(enemigo, "miss")
		}
	}
}



object enemigo1 inherits Fighter(arma = espada, vida = 100, stamina = 40, staminaMax = 40, resistencia = 0, fuerza = 5, agilidad = 3, danio = 0, position = game.at(24, 2), peso = 67, enemigo = prota,
								 clave = "Satyr", num = "02", image = "Satyr_02_Attacking_0.png", barName = barraVidaE1, barStaminaName = barraStaminaE1){
	method inicializar() {
		imageConverter.getNumberImage(self, self.num(), "Walking", 17)
		self.vida(100)
	}
}

object prota inherits Fighter(arma = espada, vida = 100, stamina = 40, staminaMax = 40, resistencia = 0, fuerza = 5, agilidad = 3, danio = 0, position = game.at(2, 2), peso = 54, enemigo = enemigo1,
								 clave = "Satyr", num = "01", image = "Satyr_01_Attacking_0.png", barName = barraVidaProta, barStaminaName = barraStaminaProta){
	var property xp = 0
	var property nextLvlAt = 40
	var property monedas = 12
	
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
		self.stamina(40)
		self.staminaMax(40)
		self.monedas(12)
		self.arma(espada)
		self.vida(100)
	}
	
	override method accionConjunta(){
		accionConjDer.accion()
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
