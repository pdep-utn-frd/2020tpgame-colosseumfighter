import wollok.game.*
import pj.*


class Modo {

    var property descripcion 
    var property velocidad
    var property pasos
	var property time
	var property final
	
    method accionPersonaje(charact){
		self.moverPersonaje(charact)
		imageConverter.getNumberImage(charact, charact.num(), descripcion, self.time())
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)
			imageConverter.getNumberImage(charact, charact.num(), "Walking", 17)
			time = final
        }
    }

	method accion(charact) {
		game.onTick(valocidad, descripcion, {=> self.accionPersonaje(charact)})
	}
	
	method moverPersonaje(charact){
		time +=1
        charact.position(charact.position().right(1))
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



object modoAtacar inherits Modo(descripcion = "Attacking", velocidad = 65, pasos = 11, time=0,final=0)		

	override method moverPersonaje(charact){
    	time+=1
        
    }    
}


object modoHurt inherits Modo(descripcion = "hurt", velocidad = 60, pasos = 11, time=0,final=0)		

	override method moverPersonaje(charact){
    	time+=1
        
    }    
}


object modoDying inherits Modo(descripcion = "dying", velocidad = 60, pasos = 11, time=0,final=0)		

	override method moverPersonaje(charact){
    	time+=1
        
    }    
}


