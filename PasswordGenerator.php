<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerador de Senha</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        form { display: inline-block; background: #f4f4f4; padding: 20px; border-radius: 10px; }
        input, button { margin-top: 10px; padding: 10px; }
    </style>
</head>
<body>

    <h2>Gerador de Senha Aleatória</h2>
    
    <form method="POST">
        <label for="length">Insira a quantidade de dígitos para a senha:</label><br>
        <input type="number" name="length" id="length" min="1" required><br>
        <button type="submit">Gerar Senha</button>
    </form>

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST")
    {
        $length = intval($_POST["length"]);

        /*
        function generatePassword($length) {
            if ($length > 6) {
                $lower = 'abcdefghijklmnopqrstuvwxyz';
                $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                $numbers = '0123456789';
                $symbols = '!@#$%^&*()_+-=[]{}|;:",.<>?/`~';
            } else {
                $alfa = 'abcdfghijklmnopqrstuvwyz';
                $numbers = '0123456789';
                $symbols = '!@#$%&*+';

                $lower = strtolower($alfa);
                $upper = strtoupper($alfa); // "ABCDFGHIJKLMNOPQRSTUVWYZ"
            }

            $all = $lower . $upper . $numbers . $symbols;
            $password = substr(str_shuffle($all), 0, $length);
        */

        function generatePassword($length)
        {
            $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:",.<>?/`~';

            $password = '';

            for ($i = 0; $i < $length; $i++)
            {
                $password .= $characters[random_int(0, strlen($characters) - 1)];
            }

            return $password;
        }

        echo "<p><strong>Senha Gerada</strong> <br> " . generatePassword($length) . "</p>";
    }
    ?>

</body>
</html>
