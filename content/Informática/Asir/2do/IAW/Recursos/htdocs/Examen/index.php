<!DOCTYPE html>
<html lang="es">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="./style/style.css">
	<title>¡Pitumundo!</title>
</head>
<body>
	<h1>Hoy en pitumundo, hemos elegido a: Papá pitufo</h1>
	<form action="./statics/p2.php" method="POST">
		<div>
			<label>Nombre: </label>
			<input type="text" name="nombre" placeholder="Papá">
		</div>
		<div>
			<label>Apellido: </label>
			<input type="text" name="apellido" placeholder="Pitufo">
		</div>
		<button type="submit">Enviar!</button>
	</form>
</body>
</html>