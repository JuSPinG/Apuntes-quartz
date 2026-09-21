<!DOCTYPE html>
<html lang="es" style="height: 100%;">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
</head>

<style>

body::before {
	content: "";
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-image: url("casino.webp");
	background-position: center center;
	background-repeat: no-repeat;
	background-size: cover;
	filter: blur(5px);
	z-index: -1;
}

@keyframes cambioColor {
	0% { background-color: green; }
	50% { background-color: orange; }
	100% { background-color: red; }
}

</style>
<body>
	<?php
		$NDados = (int)$_POST["NDados"];
		$NCaras = (int)$_POST["NCaras"];
		$puntos = (int)$_POST["puntos"];

		$puntuaciones = array();
		$misPuntos = 0;
		$susPuntos = rand(1, $puntos);

		for ($i=0; $i < $NDados; $i++) { 
			array_push($puntuaciones, rand(1, $NCaras));
			$misPuntos += $puntuaciones[$i];
		}

		$NCaras1 = $NCaras;

		if ($NCaras == 2 || $NCaras == 3 || $NCaras == 5 || $NCaras == 7 || $NCaras == 9) {
			$NCaras1 = str_replace("2", "4", $NCaras1);
			$NCaras1 = str_replace("3", "4", $NCaras1);
			$NCaras1 = str_replace("5", "6", $NCaras1);
			$NCaras1 = str_replace("7", "8", $NCaras1);
			$NCaras1 = str_replace("9", "10", $NCaras1);
		}
	?>
	<div>
		<h1 style="max-width: fit-content; margin-left: auto; margin-right: auto; font-family: Georgia, 'Times New Roman', Times, serif; font-size: 250%; background-color: black; padding: 10px; border-radius: 10px; color: white; animation: cambioColor 5s infinite alternate;">Resultado</h1>
		<p>Puntos obtenidos propios: </p>
		<input type="text" readonly value="<?php echo($misPuntos); ?>">
		<br>
		<br>
		<div style="max-width: fit-content; margin-left: auto; margin-right: auto;">
			<?php
				for ($i=0; $i < $NDados; $i++) {

					echo('<div style="position: relative; display: inline-block;">');

					if ($NCaras1 == 6) {
						$imagenGenerada = "https://www.dado-virtual.com/img/dados/" . $NCaras1 . "-caras/". $puntuaciones[$i] . "-" . $NCaras1 . "-caras.png";
					} else {
						$imagenGenerada = "https://www.dado-virtual.com/img/dados/" . $NCaras1 . "-caras/dado-" . $NCaras1 . "-caras.png";
						echo('<p style="position: absolute; top: -60px; left: 66px; font-size: 100px; z-index: 10;">' . $puntuaciones[$i] . '</p>');
					}

					echo('<img src="' . $imagenGenerada . '" style="clip-path: inset(2% 0 0 0);">');
					echo('</div>');
				}
			?>
		</div>
		<br>
		<br>
		<p>Puntos obtenidos del rival: </p>
		<input type="text" readonly value="<?php echo($susPuntos); ?>">

		<h1 style="max-width: fit-content; margin-left: auto; margin-right: auto; font-family: Georgia, 'Times New Roman', Times, serif; font-size: 150%; background-color: black; padding: 10px; border-radius: 10px;">
			<?php
				if ($misPuntos > $susPuntos) {
					echo('<span style="color: green">GANAS</span>');
				} elseif ($misPuntos == $susPuntos) {
					echo('<span style="color: orange">EMPATE</span>');
				} else {
					echo('<span style="color: red">PIERDES</span>');
				}
			?>
		</h1>
		</div>
</body>
</html>