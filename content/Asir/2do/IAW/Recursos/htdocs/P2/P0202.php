<?php

    var_export($_POST);

    echo $_POST["nombre1"];
    echo $_POST["pass1"];

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>
        Bienvenido <?php echo $_POST["nombre1"]; ?>
    </h1>
    <img src=<?php echo $_POST["img1"]; ?>>
    <form action="index.php" method="post">
		Numero: <input type="number" name="n1">
        <button type="submit">Siii</button>
    </form>
</body>
</html>