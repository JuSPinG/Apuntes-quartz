console.log("Hola"); console.log("Qué tal?");

console.error("Esto es un error");
console.warn("Esto es un aviso");

function suma(x, y) {
	return x + y;
}

console.log(suma(2, 5));

console.log(1 + 1);
console.log("1" + "1");
console.log(1 - 1);
console.log("1" - "1");

console.log("a" + "a");
console.log("a" - "a");

let texto = "Hola \\";
texto += "amigos!!";

console.log(texto);

let num = 30;
num--;
console.log(num)

let nivel = 1;

while (false) { // no se ejecuta nunca
	console.log("Alejo, me presentas a tu hermana?");
}

for (let i = 1; i >= 0; i--) { // muy importante, >= va con -- y <= va con ++
	let respuesta = prompt("Cuál es tu respuesta?");
	//console.log("Hola Nacho número: " + i);
	console.log("Te quedan " + i + " intentos");

	if (respuesta == "Sí") {
		nivel = 2;
		console.log("Eres un campeón");
		break;
	}

}
if (nivel == 1) {
	console.error("Eres un pringado");
}