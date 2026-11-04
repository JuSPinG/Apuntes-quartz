<?php

$moneda = rand(0, 5);

if ($moneda == 0) {
    echo "Cara!";
} else {
    echo "Cruz!";
}

echo "<br>";
echo "<br>";

$dados = array(rand(1, 6), rand(1, 6));
echo "La suma es de ";
echo $dados[0] + $dados[1];

echo "<br>";
echo "<br>";

$nombre = "Marcos";

echo "Hola $nombre";

for ($i=0; $i < 10; $i++) {
    echo "<br>";
    echo "Payo número: "; 
    echo $i;

    if ($i % 2 == 0) {
        echo "<br>Es un payo par!<br>";
    }
}

?>