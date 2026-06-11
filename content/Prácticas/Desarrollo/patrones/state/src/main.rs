type MaxPages = u16;

enum Planes {
	Baneado,
	Free,
	Premium
}

struct Plan {
	nivel: Planes,
	paginas_disponibles: u8
}

impl Plan {
	fn new(nivel: Planes) -> Self {
		let paginas: u8 = match nivel {
			Planes::Baneado => 0,
			Planes::Free =>  5,
			Planes::Premium => 255
		};

		return Plan { nivel: nivel, paginas_disponibles: paginas };
	}
}

struct Lector {
	nombre: String,
	plan: Plan,
	current_page: MaxPages
}

impl Lector {
	fn next_page(&mut self) {
		if self.plan.paginas_disponibles as u16 <= self.current_page {
			println!("Página siguiente bloqueada: {}", self.current_page);
		} else {
			self.current_page += 1;
			println!("Página siguiente accedida: {}", self.current_page);
		}
	}

	fn update_plan(&mut self, plan: Planes) {
		self.plan = Plan::new(plan);
	}
}

fn main() {
	let mut letctor_pro: Lector = Lector { nombre: "Juan".to_string(), plan: Plan::new(Planes::Premium), current_page: 0 };
	let mut letctor_noob: Lector = Lector { nombre: "Diego".to_string(), plan: Plan::new(Planes::Free), current_page: 0 };
	let mut letctor_hacker: Lector = Lector { nombre: "Marcos".to_string(), plan: Plan::new(Planes::Baneado), current_page: 0 };

	for _ in 0..7 {
		letctor_pro.next_page();
		letctor_noob.next_page();
		letctor_hacker.next_page();
	}

	letctor_hacker.update_plan(Planes::Free);

	for _ in 0..7 {
		letctor_pro.next_page();
		letctor_noob.next_page();
		letctor_hacker.next_page();
	}
}