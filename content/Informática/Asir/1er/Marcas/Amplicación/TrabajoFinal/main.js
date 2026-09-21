class T_Jugador {
	constructor(recursos, edificios, poblacion) {
		this.recursos = recursos;
		this.edificios = edificios;
		this.poblacion = poblacion;
		this.recursosTexto = [];
	}

	MostrarRecursos(scene) {
		
		const camera = scene.cameras.main;
		let factor = 1 / camera.zoom
		const barraRecursos = scene.add.rectangle(0, factor, camera.width, 50, 0x808080, 0.9).setScrollFactor(0).setScale(factor);
		barraRecursos.setOrigin(0, 0);

		console.log(camera.zoom, 0 + (camera.zoom)**2)
	
		let contador = 0;
		this.recursosTexto = []; // Reiniciar array
	
		for (const [clave, valor] of this.recursos) {
			const x = contador * (window.innerWidth / this.recursos.size) + 
					(window.innerWidth / (this.recursos.size * 2)) - 
					((clave.length + 2) * this.recursos.size);
					
		  	const texto = scene.add.text(x, 15, `${clave}: ${valor}`, {
				fontFamily: 'Georgia, "Goudy Bookletter 1911", Times, serif'
		  	}).setScrollFactor(0).setScale(1 / camera.zoom);
		  
		  	this.recursosTexto.push(texto); // Almacenar en array
		  	contador++;
		}
	}
	
	ActualizarRecursos() {
		let contador = 0;
		for (const [clave, valor] of this.recursos) {
			if (this.recursosTexto[contador]) {
				this.recursosTexto[contador].setText(`${clave}: ${valor}`);
			
			// Opcional: Si la posición debe actualizarse dinámicamente
				const x = contador * (window.innerWidth / this.recursos.size) + 
						(window.innerWidth / (this.recursos.size * 2)) - 
						((clave.length + 2) * this.recursos.size);
				this.recursosTexto[contador].setPosition(x, 15);
			}
			contador++;
		}
	}

	ComprobarRecursos() {
		for (int = 0; i < length(this.recursos); i++) {
			if (this.recursos[i] < 0) {
				throw 1; // Error: No hay suficientes recursos
			}
		}
	}
}

class T_Hexagono {
	constructor(tipo, valor) {
		this.tipo = tipo;
		this.valor = valor;
	}

	InsertarImagen() {
		switch (this.tipo) {
			case 0:
				return "Bosque";
			case 1:
				return "Montanna";
			case 2:
				return "Desierto";
			case 3:
				return "Mar";
			default:
				break;
		}
	}

	TiposRecursos() {
		switch (this.tipo) {
			case 0:
				return "Madera";
			case 1:
				return "Piedra";
			case 3:
				return "Comida";
			default:
				break;
		}
	}

	CrearHexagono(scene, x, y, size, rotation = 30) {
		const initialScale = 0.2;
		const points = [];
		for (let i = 0; i < 6; i++) {
			// Añadimos la rotación al ángulo base
			const angle = Phaser.Math.DegToRad(60 * i + rotation);
			points.push({
				x: x + size * Math.cos(angle),
				y: y + size * Math.sin(angle),
			});
		}

		const graphics = scene.add.graphics();

		graphics.fillStyle(0xffffff, 1);
		graphics.beginPath();
		graphics.moveTo(points[0].x, points[0].y);
		points.forEach((point) => graphics.lineTo(point.x, point.y));
		graphics.closePath();
		graphics.fillPath();

		const image = scene.add.image(x, y, this.InsertarImagen());
		//const valorTexto = scene.add.text(0, 0, this.valor);
		// const polygon = new Phaser.Geom.Polygon(points.map(p => [p.x, p.y]).flat());
		image.setInteractive({
			// hitArea: polygon,
			hitArea: new Phaser.Geom.Rectangle(0, 0, image.width, image.height),
			hitAreaCallback: Phaser.Geom.Rectangle.Contains,
			useHandCursor: true,
			pixelPerfect: false,
			alphaTolerance: 1
		});
		image.setScale(initialScale); // Por ejemplo
		graphics.lineStyle(2, 0x000000, 1);
		graphics.strokePoints(points, true);


		const mask = graphics.createGeometryMask();
		image.setMask(mask);

		// Dibuja el área interactiva para verla en tiempo real
		image.on("pointerover", () => {
			image.setScale(initialScale + 0.01);
		});

		image.on("pointerout", () => {
			image.setScale(initialScale);
		});

		return image;

	}

	ExtraerRecursos(jugador) {
		if (this.tipo != 2) {
			let tipoRecurso = this.TiposRecursos()
			let recurso = jugador.recursos.get(tipoRecurso) + this.valor;
			jugador.recursos.set(tipoRecurso, recurso);
			console.log(recurso);
			jugador.ActualizarRecursos();
		}
	}
}

class T_Mapa {
	constructor() {
		this.malla = [];
	}

	CrearMalla(scene, radius, size, offsetX, offsetY, jugador) {
		let contador = 0;
		// Iteramos sobre cada coordenada axial
		for (let q = -radius; q <= radius; q++) {
			for (let r = Math.max(-radius, -q - radius); r <= Math.min(radius, -q + radius); r++) {

				this.malla.push(new T_Hexagono(Math.floor(Math.random() * 4), Math.floor(Math.random() * MAX_Puntuacion)))

				// La coordenada s se calcula automáticamente (q + r + s = 0)
				const s = -q - r;

				// Convertimos coordenadas axiales a píxeles
				const x = offsetX + size * (Math.sqrt(3) * q + Math.sqrt(3) / 2 * r);
				const y = offsetY + size * (3 / 2 * r);

				const hexagono = this.malla[contador];
				const imagen = hexagono.CrearHexagono(scene, x, y, size)
				
				imagen.on("pointerdown", () => {
					console.log(arrastre);
					if (!arrastre) {
						hexagono.ExtraerRecursos(jugador);
					}
				});

				contador++;
			}
		}
	}
}
const config = {
	type: Phaser.CANVAS,
	width: window.innerWidth,
	height: window.innerHeight,
	scene: {
		preload: preload,
		create: create,
	},
	backgroundColor: "#2d2d2d",
	input: {
		activePointers: 3,
		mouse: true,    // Necesario para desktop
		touch: false,     // Necesario para móviles
		keyboard: true
	}
};

const game = new Phaser.Game(config);
const MAX_Puntuacion = 10;

const jugador = new T_Jugador;
const mapa = new T_Mapa;
var arrastre = false;

jugador.recursos = new Map;

jugador.recursos.set("Comida", 0);
jugador.recursos.set("Madera", 0);
jugador.recursos.set("Piedra", 0);
jugador.recursos.set("Oro", 0);
jugador.recursos.set("Influencia", 0);
jugador.recursos.set("Poblacion", 0);

function preload() {
	this.load.image("Montanna", "img/Montanna.png");
	this.load.image("Bosque", "img/Bosque.png");
	this.load.image("Desierto", "img/Desierto.png");
	this.load.image("Mar", "img/Mar.png");

}

function create() {
	const hexSize = 40; // Radio del hexágono
	const radius = 5; // Radio del tablero (número de anillos)
	const offsetX = window.innerWidth / 2; // Centro en X
	const offsetY = window.innerHeight / 2; // Centro en Y

	mapa.CrearMalla(this, radius, hexSize, offsetX, offsetY, jugador);
	jugador.MostrarRecursos(this);

	const camera = this.cameras.main;
	let posicionInicial = { x: 0, y: 0 };
	camera.preRender();
	camera.setPosition(posicionInicial.x, posicionInicial.y);
	//camera.setSize(0, 0); // Origen de todos los males

	worldView = camera.worldView;

	// Arrastre del mapa

	const CtrlBar = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.CTRL);

	CtrlBar.on("down", () => {
		arrastre = true;
	});

	this.input.on("pointerdown", (pointer) => {
		if (arrastre) {
			posicionInicial.x = pointer.x;
			posicionInicial.y = pointer.y;
		}
	});
			
	this.input.on("pointerup", (pointer) => {
		if (arrastre) {
			// Calcula el desplazamiento del puntero
			const deltaX = pointer.x - posicionInicial.x;
			const deltaY = pointer.y - posicionInicial.y;
		
			// Mueve la cámara en la dirección opuesta al arrastre (para efecto "drag")
			camera.scrollX -= deltaX;
			camera.scrollY -= deltaY;
		}
	});
	

	CtrlBar.on("up", () => {
		arrastre = false;
	});


	window.addEventListener("wheel", (event) => {
		jugador.MostrarRecursos(this)
		if (event.deltaY > 0 && camera.zoom > 0) {
			camera.zoom -= 0.05;
		} else if (event.deltaY < 0) {
			camera.zoom += 0.05;
		}
	});
}
