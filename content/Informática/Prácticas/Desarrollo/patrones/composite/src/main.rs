trait Identificable {
	fn extraer_indice(&self) -> &str;
}

impl Identificable for &str {
	fn extraer_indice(&self) -> &str { self }
}

impl<'a> Identificable for &'a Nodo {
	fn extraer_indice(&self) -> &str { &self.indice }
}

#[derive(Debug, Clone)]
struct Nodo {
	indice: String,
	nombre: String,
	hijos: Option<Vec<Box<Nodo>>>,
	padre: Option<Box<Nodo>>
}

impl Nodo {

	fn new(cadena_completa: &str, nodos: &Vec<Nodo>) -> Self {

		if let Some((indice, nombre)) = cadena_completa.split_once(" ") {

			let mut padre: Option<Box<Nodo>> = None;

			for otros_nodos in nodos {
				if indice.to_string().starts_with(&otros_nodos.indice) &&
				Nodo::obtener_profundidad(&Nodo { indice: indice.to_string(), nombre: nombre.to_string(), hijos: None, padre: None }) == &otros_nodos.obtener_profundidad() + 1 {
					padre = Some(Box::new(Nodo::clone(otros_nodos)));
					break;
				}
			}

			Nodo {
				indice: indice.to_string(),
				nombre: nombre.to_string(),
				padre: padre,
				hijos: None
			}
			
		} else {
			// Caso de emergencia por si la cadena no tiene espacios
			Nodo {
				indice: "".to_string(),
				nombre: cadena_completa.to_string(),
				padre: None,
				hijos: None
			}
		}
	}

	fn obtener_profundidad(&self) -> usize {
		return self.indice.split(".").count();
	}

	fn presentar(&self) {
		println!("{}{} {}", "    ".repeat(self.obtener_profundidad()), self.indice, self.nombre);
	}
}

fn main() {
	let apuntes: Vec<&str> = vec!["1. Introducción", "1.1. Consideraciones a la hora de seguir el curso de Python", "1.2. Historia y características de Python", "2. Tipos de datos", "2.1. Tipos de datos simples", "2.1.1. Tipo numérico", "2.1.2. Declaración de variables", "2.1.3. La función print", "2.2. Tipos de datos compuestos", "2.2.1. Tipo lista", "2.2.2. Índices y slicing", "2.2.3. La función input"];
	let mut nodos: Vec<Nodo> = vec![];

	for i in apuntes {
		let t_nodo: Nodo = Nodo::new(i, &nodos);
		nodos.push(t_nodo);
	}

	println!("{:#?}", nodos);
}