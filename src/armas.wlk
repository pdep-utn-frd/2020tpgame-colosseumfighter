import wollok.game.*

object espada {

	var property image = "warrior.png"
	var property position = game.at(7, 2)
	var property coste = 5
	var property danio = 10

	method peso() {
		return 2
	}

	method nombre() {
		return self
	}

	method es() {
		return "arma"
	}

}

object manos {

	method danio() {
		return 4
	}

	method coste() {
		return 0
	}

	method peso() {
		return 0
	}

}

object lanza {

	method danio() {
		return 12
	}

	method coste() {
		return 8
	}

	method peso() {
		return 1.2
	}

}

