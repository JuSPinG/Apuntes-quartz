<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="../style/style.css">
    <title>¡Pitumundo!</title>
</head>
<body>
    <?php
        $puntuación = $_POST["número"]*rand(1, 5)*100;
    ?>
	<h1>Hoy en pitumundo, hemos elegido a: Papá pitufo</h1>
    <div>
        <p>Puntos para el premio:</p>
        <h1 style="font-size: 2000%; margin-top: 0; margin-bottom: 0;"><?php echo $puntuación ?></h1>
    </div>

    <?php
        if ($puntuación >= 3000) {
            echo "<p>ENHORABUENA DE LA BUENA</p>";
        }
    ?>

    <button type="button" onclick="window.location.href='../index.php'">Volver a probar suerte de nuevo</button>
</body>
</html>