numClase = 23;

console.log("Número: " + ((numClase % 5) + 6));

/*==============================
  Pregunta número 9
===============================*/

let num = (Math.floor(Math.random() * (2**8)-1)).toString(2).padStart(8, "0");
alert(num);

let palabra1 = prompt("Introduce una palabra: ");
let palabra2 = prompt("Introduce una palabra: ");
let palabra3 = prompt("Introduce una palabra: ");

if (!((palabra1 == palabra2) && (palabra2 == palabra3))) {
  console.log("DISTINTAS!");
}

console.log(10--); // da 9, le resta un número a 10 y luego imprime el resultado