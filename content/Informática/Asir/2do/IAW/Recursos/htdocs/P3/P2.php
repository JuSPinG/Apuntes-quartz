<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>alert(
        <?php
            if (strtolower($_POST["nombre1"]) == "alberto" && $_POST["pass1"] == 64) {
                echo "'Bieen'";
            } else {
                echo "'Soplagaitas'";
            }
        ?>
    )</script>
</body>
</html>