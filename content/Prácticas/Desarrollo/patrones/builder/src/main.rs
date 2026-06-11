
#[derive(Debug)]
enum Pan {
	Brioche,
	_Integral,
	Normal
}

#[derive(Debug)]
enum Proteina {
	Ternera,
	Pollo,
	_Vegana
}

#[derive(Debug)]
struct Hamburguesa {
	pan: Pan,
	proteina: Proteina,
	queso: bool,
	tomate: bool,
	lechuga: bool,
	n_bacon: u8
}

impl Hamburguesa {
	fn new() -> Self {
		Hamburguesa {
			pan: Pan::Normal,
			proteina: Proteina::Ternera,
			queso: false,
			tomate: false,
			lechuga: false,
			n_bacon: 0
		}
	}
}

struct HamburguesaBuilder {
	hamburguesa: Hamburguesa
}

impl HamburguesaBuilder {
	fn new() -> Self {
		HamburguesaBuilder {
			hamburguesa: Hamburguesa::new()
		}
	}

	fn elegir_pan(mut self, pan: Pan) -> Self {
	   self.hamburguesa.pan = pan;
	   return self;
	}

	fn elegir_proteina(mut self, proteina: Proteina) -> Self {
		self.hamburguesa.proteina = proteina;
		return  self;
	}

	fn poner_queso(mut self) -> Self {
		self.hamburguesa.queso = true;
		return self;
	}
	
	fn poner_tomate(mut self) -> Self {
		self.hamburguesa.tomate = true;
		return self;
	}
	
	fn poner_lechuga(mut self) -> Self {
		self.hamburguesa.lechuga = true;
		return self;
	}
	
	fn poner_bacon(mut self, lonchas: u8) -> Self {
		self.hamburguesa.n_bacon = lonchas;
		return self;
	}

	fn build(self) -> Hamburguesa {
		return self.hamburguesa;
	}
}

fn main() {
	println!("Bienvenidos a mi restaurante!\n\nOs serviré una hamburguesa básica, mediana, y muy completa.\n");

	let hamburguesa_basica: Hamburguesa = HamburguesaBuilder::new().build();

	let hamburguesa_mediana: Hamburguesa = HamburguesaBuilder::new()
		.poner_lechuga()
		.poner_queso()
		.poner_tomate()
		.build();

	let hamburguesa_completa: Hamburguesa = HamburguesaBuilder::new()
		.elegir_pan(Pan::Brioche)
		.elegir_proteina(Proteina::Pollo)
		.poner_bacon(3)
		.poner_lechuga()
		.poner_queso()
		.poner_tomate()
		.build();

	println!("Básica: {:#?}", hamburguesa_basica);
    println!("Mediana: {:#?}", hamburguesa_mediana);
    println!("Completa: {:#?}", hamburguesa_completa);
}