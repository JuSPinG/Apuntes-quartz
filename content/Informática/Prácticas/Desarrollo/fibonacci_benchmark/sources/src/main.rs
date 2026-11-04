use serde::{Deserialize, Serialize};
use std::env;
use std::fs::File;
use std::io::{BufReader, BufWriter};

// 1. Añadimos Serialize y Deserialize a tu estructura para que Serde sepa cómo leerla/escribirla
#[derive(Serialize, Deserialize, Debug)]
struct Datos {
    lenguaje: String,
    tiempo: f32,
}

impl Datos {
    fn new() -> Self {
        let args: Vec<String> = env::args().collect();

        // CORRECCIÓN: Para recibir el lenguaje y el tiempo, el tamaño debe ser exactamente 3
        // args[0] = nombre del programa, args[1] = lenguaje, args[2] = tiempo
        if args.len() != 3 {
            eprintln!(
                "Error: Argumentos inválidos. Uso correcto: cargo run -- <lenguaje> <tiempo>"
            );
            std::process::exit(1);
        }

        Datos {
            lenguaje: args[1].clone(),
            // Simplificamos el parseo con un expect directo
            tiempo: args[2]
                .parse()
                .expect("El segundo argumento debe ser un número decimal válido"),
        }
    }
}

struct EditorJson {
    ruta: String,                 // Guardamos la ruta para poder guardar los cambios luego
    contenido: serde_json::Value, // CORRECCIÓN: 'serde_json' es el módulo; el tipo dinámico es 'Value'
    datos_nuevos: Datos,
}

impl EditorJson {
    fn new(ruta: &str) -> Self {
        // Abrimos el archivo para lectura
        let archivo = File::open(ruta).expect("No se pudo abrir el archivo JSON. ¿Existe?");
        let lector = BufReader::new(archivo);

        // Leemos el JSON como un valor genérico (Value)
        let contenido: serde_json::Value =
            serde_json::from_reader(lector).expect("El archivo no contiene un JSON válido");

        // Capturamos los datos que pasó el usuario por consola
        let datos = Datos::new();

        EditorJson {
            ruta: ruta.to_string(),
            contenido,
            datos_nuevos: datos,
        }
    }

    // NUEVO MÉTODO: Añade los datos recolectados al JSON y sobreescribe el archivo
    fn agregar_y_guardar(mut self) {
        // Nos aseguramos de que el archivo sea una lista (Array) de JSON para poder hacer un .push()
        if !self.contenido.is_array() {
            println!("El JSON no era una lista. Inicializando una nueva lista vacía...");
            self.contenido = serde_json::json!([]);
        }

        // Convertimos nuestra estructura 'Datos' a un elemento JSON
        let nuevo_elemento = serde_json::to_value(&self.datos_nuevos).unwrap();

        // Modificamos el contenido añadiendo el nuevo elemento
        if let Some(lista) = self.contenido.as_array_mut() {
            lista.push(nuevo_elemento);
        }

        // Abrimos el archivo en modo escritura (esto limpia el archivo anterior)
        let archivo_escritura = File::create(&self.ruta).expect("No se pudo escribir en el archivo");
        let escritor = BufWriter::new(archivo_escritura);

        // Guardamos todo con formato limpio e indentado
        serde_json::to_writer_pretty(escritor, &self.contenido)
            .expect("Error al guardar los datos en el archivo");

        println!(
            "¡Éxito! Se añadió '{}' con un tiempo de {} al archivo.",
            self.datos_nuevos.lenguaje, self.datos_nuevos.tiempo
        );
    }
}

fn main() {
    // Inicializamos el editor leyendo el archivo y los argumentos de la consola
    let editor = EditorJson::new("../sources/results.json");

    // Ejecutamos la fusión de datos y guardamos
    editor.agregar_y_guardar();
}