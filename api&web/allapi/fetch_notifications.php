<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_id = $_GET['user_id'];

// Fetch the most recent notification
$sql = "SELECT * FROM notifications WHERE user_id='$user_id' ORDER BY date DESC LIMIT 1";
$result = $conn->query($sql);

$notifications = [];
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $notifications[] = $row;
    }
}

// Set Content-Type header to application/json
header('Content-Type: application/json');

// Output the JSON encoded data
echo json_encode($notifications);

$conn->close();
?>
