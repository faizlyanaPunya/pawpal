<?php
$servername = "localhost";
$username = "musicbvk_faiz";
$password = "socstudent_faiz";
$database = "musicbvk_pawpal_db_faiz";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
