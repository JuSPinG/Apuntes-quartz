<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hackéame si puedes</title>
</head>
<body>
    <form action="#" method="get">
        <label>Introduce tu nombre: </label>
        <input type="text" name="nombre">
        <input type="submit" value="Dame!">
    </form>

    <?php
    
    if (sizeof($_GET) > 0) {
        echo "Tu nombre es: " . htmlspecialchars($_GET["nombre"]);
    }
    ?>
</body>
</html>