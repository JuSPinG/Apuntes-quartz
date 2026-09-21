/*-- Nombres ASIR --*/
console.log("Marcos");
console.log("ELena");
console.log("Isma");
console.log("Gonzalo");
console.log("Alejo");

function ImprimirNombres() {
	console.log("Marcos");
	console.log("ELena");
	console.log("Isma");
	console.log("Gonzalo");
	console.log("Alejo");
}

function Imprimir(texto) {
	console.log(texto);
}

Imprimir("Hola a todos");
// texto = "Hola a todos";

function Suma(n1, n2) {
	return n1 + n2;
}

let numero = Suma(20, 40);
console.log(numero);

console.log(Suma(1, 3));

// Esto es un comentario

/*
Esto es
Un comentario
Multilinea
*/

const para = document.createElement("p");
para.innerText = "This is a paragraph";
document.body.appendChild(para);