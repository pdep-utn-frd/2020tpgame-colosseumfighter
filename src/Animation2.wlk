import wollok.game.*
import objetos.*


const accionConjDer = new AccionConj(charact =prota, enem=enemigo1)
 
object accionConjizq inherits AccionConj(charact =enemigo1, enem=prota){
	
	override method caminar(){
		modoWalkingL.accion(charact)
	}
	
	override method volver(){
		modoWalkingR.accion(charact)
	}
}

class Modo {

    var property descripcion 
    var property velocidad
    var property pasos
	var property time
	var property final
	
    method accionPersonaje(charact){
		self.moverPersonaje(charact)
		imageConverter.getNumberImage(charact, charact.num(), descripcion, (self.time().toString()))
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)
        	if (descripcion != "dying"){
				imageConverter.getNumberImage(charact, charact.num(), "Walking", "4")}
			time = final
        }
    }

	method accion(charact) {
		game.onTick(velocidad, descripcion, {=> self.accionPersonaje(charact)})
		
	}
	
	method moverPersonaje(charact){
		time +=1
	}
	
}
object modoWalkingR inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 16, time=0,final=0) {

    override method moverPersonaje(charact){
    	time+=1
        charact.position(charact.position().right(1))
    }    
}
object modoWalkingL inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 0, time=17,final=17) {

    override method moverPersonaje(charact){
		time -=1
        charact.position(charact.position().left(1))
    }
}
const modoAtacar = new Modo(descripcion = "Attacking", velocidad = 65, pasos = 11, time=0,final=0)	

const modoHurt = new Modo(descripcion = "hurt", velocidad = 60, pasos = 11, time=0,final=0)

const modoDying = new Modo(descripcion = "dying", velocidad = 60, pasos = 11, time=0,final=0)

class AccionConj{
	
	var property charact
	var property enem
	
	method caminar(){
		modoWalkingR.accion(charact)
	}
	method volver(){
		modoWalkingL.accion(charact)
	}
	method accion(){
		self.caminar()
		game.schedule(660, { modoAtacar.accion(charact)})
		
		game.schedule(1250, { modoHurt.accion(enem)
								game.schedule(980, { if (enem.vida() == 0) {modoDying.accion(enem)} })})
		game.schedule(1580,{ self.volver()})	
	}
}

object imageConverter {

	method getNumberImage(pj, num, accion, time) {
		pj.image(pj.clave() + "_" + num + "_" + accion + "_" + time + ".png")
	}
}

