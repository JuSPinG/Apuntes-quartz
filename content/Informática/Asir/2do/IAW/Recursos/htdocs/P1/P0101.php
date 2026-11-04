<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div style="max-width: fit-content; margin-left: auto; margin-right: auto;">
        <h1>ENHORABUENA</h1>
        <h2> de la </h2>
        <h1>
            <?php

            $n = rand(0, 1);

            if ($n) {
                echo "MALA";
            } else {
                echo "BUENA";
            }

            ?>
        </h1>
        <h4>pero</h4>
        <h1>
            <?php

                if ($n) {
                    echo "NADA";
                } else {
                    echo "TODO";
                }

            ?>
        </h1>
        <h2>VIVA</h2>
        <img width="250px" height="auto" src=
            <?php

                $familia = array(
                    "Homero.avif",
                    "Lisa.webp",
                    "Marge.jpeg"
                );

                echo $familia[rand(0, 2)];

            ?>
        >
    </div>
</body>
</html>