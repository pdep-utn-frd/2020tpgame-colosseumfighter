
import wollok.game.*
import pj.*

object animator{
	var property timeA = 0
	var property timeW = 0
	var property timeB = 0
	var property timeH = 0
	var property timeD = 0

//-----------------------------------------------------Atacar---------------------------------------------------------------//	
	method atacar(charact){	
		self.timeA(0)		
		game.onTick(65,"atacando",{=> self.sumarAtaque(charact,timeA)})
	}	
	method sumarAtaque(charact,time){
		self.timeA(self.timeA()+1)	
//		charact.image("Satyr_01_Attacking_0.png")	
		imageConverter.getNumberImage(charact,charact.num(),"Attacking",self.timeA())

		if (self.timeA() == 11)
		  {game.removeTickEvent("atacando") 
		  imageConverter.getNumberImage(charact,charact.num(),"Walking",17)
		  self.timeA(0)
		  }	 
	}
//-------------------------------------------------Caminar-Derecha----------------------------------------------------------//		
	method walkingR(charact){
		self.timeW(0)
		game.onTick(40,"caminar",{=> self.sumarWalking(charact)})
	}
	method sumarWalking(charact){
		self.timeW(self.timeW()+1)	
		charact.position(charact.position().right(1))
		charact.barName().posicion(charact)
		imageConverter.getNumberImage(charact,charact.num(),"Walking",self.timeW())
		if (self.timeW() == 16)
		  {game.removeTickEvent("caminar") 
		charact.barName().posicion(charact)
		  imageConverter.getNumberImage(charact,charact.num(),"Walking",17)
		  self.timeW(0)
		}
	}
//-------------------------------------------------Caminar-Izquierda--------------------------------------------------------//
	method walkingL(charact){
		self.timeB(17)
		game.onTick(40,"backward",{=> self.sumarWalkingL(charact)})
	}
	method sumarWalkingL(charact){
		self.timeB(self.timeB()-1)	
		charact.position(charact.position().left(1))
		charact.barName().posicion(charact)
		imageConverter.getNumberImage(charact,charact.num(),"Walking",self.timeB())
		if (self.timeB() == 1)
		  {game.removeTickEvent("backward") 
		charact.barName().posicion(charact)
		  imageConverter.getNumberImage(charact,charact.num(),"Walking",17)
		  self.timeB(17)
		  }
	}
//------------------------------------------------------Herida--------------------------------------------------------------//
	method hurt(charact){
		game.onTick(60,"hurt",{=>self.sumarHurt(charact)})
	}
	method sumarHurt(charact){
		self.timeH(self.timeH()+1)
		imageConverter.getNumberImage(charact,charact.num(),"Hurt",self.timeH())
		if(self.timeH() == 11)
			{game.removeTickEvent("hurt")
		     imageConverter.getNumberImage(charact,charact.num(),"Walking",17)
		     self.timeH(0)
			}			
	}
//------------------------------------------------------Dead--------------------------------------------------------------//
	method dying(charact){
		game.onTick(60,"dying",{=>self.sumarDying(charact)})
	}
	method sumarDying(charact){
		self.timeD(self.timeD()+1)
		imageConverter.getNumberImage(charact,charact.num(),"Dying",self.timeD())
		if(self.timeD() == 11)
			{game.removeTickEvent("dying")
		     self.timeD(0)
			}			
	}
	
//--------------------------------------------------Caminar+Atacar-Derecha----------------------------------------------------------//		
	method attackActionR(charact,enem){
	  self.walkingR(charact)
	  game.onTick(1000,"animationAttackR",{=>self.atacar(charact)  game.removeTickEvent("animationAttackR")})
  	  if (enem.vida()<=0){game.onTick(1695,"animacionDying",{=>self.dying(enem) game.removeTickEvent("animacionDying")})}
	  else{game.onTick(1695,"animacionGolpeR",{=>self.hurt(enem) game.removeTickEvent("animacionGolpeR")})}
	  game.onTick(2410,"animacionBackwardR",{=>self.walkingL(charact) game.removeTickEvent("animacionBackwardR")})
	}
//--------------------------------------------------Caminar+Atacar-Izquierda--------------------------------------------------------//

	method attackActionL(charact,enem){
	  self.walkingL(charact)
	  game.onTick(1000,"animationAttackL",{=>self.atacar(charact)  game.removeTickEvent("animationAttackL")})
	  if (enem.vida()<=0){game.onTick(1695,"animacionDying",{=>self.dying(enem) game.removeTickEvent("animacionDying")})}
	  else{game.onTick(1695,"animacionGolpeL",{=>self.hurt(enem) game.removeTickEvent("animacionGolpeL")})}
	  game.onTick(2410,"animacionBackwardL",{=>self.walkingR(charact) game.removeTickEvent("animacionBackwardL")})
	}
}