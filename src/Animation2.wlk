import wollok.game.*
import pj.*


class Modo {

    var property descripcion 
    var property velocidad
    var property pasos
	var property time
	
    method accionPersonaje(charact){

    }

	method accion(charact) {
		game.onTick(pasos, descripcion, {=> self.accionPersonaje(charact)})
	}
}


object modoWalkingR inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 16, time=0) {

    override method accionPersonaje(charact){
    	self.time(self.time()+1)
        charact.position(charact.position().right(1))
        charact.barName().position(charact)
        imageConverter.getNumberImage(charact, charact.num(), descripcion, self.time())
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)
			charact.barName().position(charact)
			imageConverter.getNumberImage(charact, charact.num(), "Walking", 17)
			self.time(0)
        }
    }
}

object modoWalkingL inherits Modo(descripcion = "Walking", velocidad = 40, pasos = 0, time=17) {

    override method accionPersonaje(charact){
    	self.time(self.time()-1)
        charact.position(charact.position().left(1))
        charact.barName().position(charact)
        imageConverter.getNumberImage(charact, charact.num(), descripcion, self.time())
        if (self.time() == pasos) {
        	game.removeTickEvent(descripcion)
			charact.barName().posicion(charact)
			imageConverter.getNumberImage(charact, charact.num(), "Walking", 17)
			self.time(17)
        }
    }
}

