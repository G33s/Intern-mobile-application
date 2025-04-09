<?php
header('Content-Type: application/json');
$servername = "localhost";
$username = "username";
$password = "password";
$dbname = "account_inform";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_id = intval($_GET['user_id']);
$sql = "SELECT * FROM jobs WHERE user_id = $user_id";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $jobs = array();
    while($row = $result->fetch_assoc()) {
        $jobs[] = $row;
    }
    echo json_encode($jobs);
} else {
    echo json_encode(array());
}

$conn->close();
?>
