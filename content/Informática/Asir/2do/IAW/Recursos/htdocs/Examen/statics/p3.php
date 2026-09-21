<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="../style/style.css">
	<title>¡Pitumundo!</title>
</head>
<body>
	<h1>Hoy en pitumundo, hemos elegido a: Papá pitufo</h1>
	<?php
		echo "<ol>";
		foreach ($_POST as $key => $value) {
			echo "
				<li>" . $key . ": " . $value . "</li>
			";
		}
		echo "</ol>";
	?>
	<form action="p4.php" method="POST">
		<div>
			<input type="text" name="nombre" value="<?php echo $_POST["nombre"]; ?>" readonly hidden>
			<input type="text" name="apellido" value="<?php echo $_POST["apellido"]; ?>" readonly hidden>
			<input type="number" name="edad" value="<?php echo $_POST["edad"]; ?>" readonly hidden>
			<input type="number" name="número" value="<?php echo $_POST["número"][-1]; ?>" readonly hidden>
		</div>
		<button type="submit">Enviar!</button>
	</form>
</body>
</html>