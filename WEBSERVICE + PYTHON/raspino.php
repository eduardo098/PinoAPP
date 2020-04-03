<?php

$host = 'localhost';
$user = 'root';
$pass = '';
$db = 'db_arduino';

$mysqli = new mysqli($host,$user,$pass,$db);

if ($mysqli->connect_errno) {
    echo ($mysqli->connect_errno);
    echo ($mysqli->connect_error);
}

if($_SERVER["REQUEST_METHOD"] === "POST") {
    $humedad = $_POST['humedad'];
    $temperatura = $_POST['temperatura'];

    $query = "INSERT INTO tbl_pino (humedad, temperatura) VALUES ('$humedad', '$temperatura')";
    $result = $mysqli->query($query);

    if($result) {
        echo ("Exito!");
    } else {
        echo ("Fallo :(");
    }
}

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $reqType = $_GET["type"];

    if ($reqType === "stats") {
        $query = "SELECT * FROM tbl_pino ORDER BY id DESC LIMIT 1";
        $result = $mysqli->query($query);
        if ($result) {
            foreach ($result as $row):
                $res[] = $row;
            endforeach;
            
            echo json_encode($res);
        }
    } else if ($reqType === "graphs") {
        $query = "SELECT humedad, 
                        temperatura, 
                        YEAR(fecha_info) as year,
                        MONTH(fecha_info) as month,
                        DAY(fecha_info) as day
                        FROM tbl_pino";

        $result = $mysqli->query($query);
        if ($result) {
            foreach ($result as $row):
                $res[] = $row;
            endforeach;    

            echo json_encode($res);
        }
    }
}