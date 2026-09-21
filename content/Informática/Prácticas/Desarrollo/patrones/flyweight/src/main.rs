use std::time::Instant;
use num_bigint::BigUint;
use num_traits::{Zero, One};
use std::mem;

const LIMITE: usize = 500000;
const NIVEL_IMPRESION: Impresion = Impresion::Ninguno;

struct Cronometro {
	etiqueta: String,
	inicio: Instant,
}

impl Cronometro {
	fn nuevo(etiqueta: &str) -> Self {
		Self {
			etiqueta: etiqueta.to_string(),
			inicio: Instant::now(),
		}
	}
}

impl Drop for Cronometro {
	fn drop(&mut self) {
		println!("⏱️  [{}] Fin de ejecución. Duración: {:?}", self.etiqueta, self.inicio.elapsed());
	}
}

#[derive(PartialEq)]
enum Impresion {
	Ninguno,
	Ultimo,
	Todo
}

trait CalcularFibonacci {
	fn calcular(&self);
}

struct FibonacciCache {
	limite: usize,
	impresion: Impresion,
	nombre: String
}

impl CalcularFibonacci for FibonacciCache {

	fn calcular(&self) {
		let _timer: Cronometro = Cronometro::nuevo(&self.nombre);

		let mut cache_numeros: Vec<BigUint> = vec![BigUint::zero(), BigUint::one()];

		if cache_numeros.len() > self.limite {
			return;
		}

		for indice in cache_numeros.len()..=self.limite {
			// La suma de BigUints clona/crea un nuevo número gigante en memoria
			let siguiente = &cache_numeros[indice - 1] + &cache_numeros[indice - 2];
			cache_numeros.push(siguiente);
			if self.impresion == Impresion::Todo {
				println!("{} : {}", indice, cache_numeros[indice]); // Aumento altísimo de tiempo
			}
		}
		
		if self.impresion == Impresion::Ultimo {
			println!("{} : {}", self.limite, cache_numeros[cache_numeros.len() - 1]);
		}
	}	
}

impl FibonacciCache {
	fn new() -> Self {
		return Self {
			limite: LIMITE,
			impresion: NIVEL_IMPRESION,
			nombre: "FibonacciCache".to_string()
		};
	}
}

struct FibonacciIterativo {
	limite: usize,
	impresion: Impresion,
	nombre: String,
	mem_swap: bool
}

impl CalcularFibonacci for FibonacciIterativo {

	fn calcular(&self) {
		let _timer: Cronometro = Cronometro::nuevo(&self.nombre);

		let mut a = BigUint::zero();
		let mut b = BigUint::one();

        // El if se evalúa una vez aquí, dentro del bucle solo hay aritmética.
        if self.mem_swap {
            for _ in 2..=self.limite {
                a += &b;
                mem::swap(&mut a, &mut b);
            }
        } else {
            // Versión sin swap: crea un BigUint nuevo por iteración
            for _ in 2..=self.limite {
                let siguiente = &a + &b;
                a = b;
                b = siguiente;
            }
        }
		
		if self.impresion == Impresion::Ultimo {
			println!("{} : {}", self.limite, b);
		}
	}	
}

impl FibonacciIterativo {
	fn new(nombre: &str, mem_swap: bool) -> Self {
		return Self {
			limite: LIMITE,
			impresion: NIVEL_IMPRESION,
			nombre: nombre.to_string(),
			mem_swap: mem_swap
		};
	}
}

struct FibonacciDoblado {
	limite: usize,
	impresion: Impresion,
	nombre: String
}

impl CalcularFibonacci for FibonacciDoblado {
    fn calcular(&self) {
        let _timer = Cronometro::nuevo(&self.nombre);
 
        // Función interna recursiva que devuelve (F(n), F(n+1))
        fn helper(n: usize) -> (BigUint, BigUint) {
            if n == 0 {
                return (BigUint::zero(), BigUint::one());
            }
 
            let (fk, fk1) = helper(n >> 1); // F(k), F(k+1)  donde k = n/2
 
            // F(2k) = F(k) · (2·F(k+1) − F(k))
            let dos_fk1 = &fk1 << 1usize;           // 2·F(k+1)  — desplazamiento de bits
            let dos_fk1_menos_fk = dos_fk1 - &fk;   // siempre ≥ 0 con BigUint
            let c = &fk * &dos_fk1_menos_fk;
 
            // F(2k+1) = F(k)² + F(k+1)²
            let d = &fk * &fk + &fk1 * &fk1;
 
            if n & 1 == 0 {
                (c, d)          // n par  → (F(2k),   F(2k+1))
            } else {
                (d.clone(), c + d)      // n impar → (F(2k+1), F(2k+2))
            }
        }
 
        let resultado = helper(self.limite).0;
 
        if self.impresion == Impresion::Ultimo {
            println!("{} : {}", self.limite, resultado);
        }
    }
}

impl FibonacciDoblado {
	fn new(nombre: &str) -> Self {
		return Self {
			limite: LIMITE,
			impresion: NIVEL_IMPRESION,
			nombre: nombre.to_string(),
		};
	}
}

fn main() {
	FibonacciCache::new().calcular();
	FibonacciIterativo::new("FibonacciIterativo", false).calcular();
	FibonacciIterativo::new("FibonacciIterativoMemSwap", true).calcular();
	FibonacciDoblado::new("FibonacciDoblado").calcular();
}