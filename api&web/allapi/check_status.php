<?php
// Database connection
$servername = "localhost"; 
$username = "root"; 
$password = ""; 
$dbname = "car_status"; 

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from the request (assuming you send it via POST)
$user_id = isset($_POST['user_id']) ? intval($_POST['user_id']) : null;
$status_1 = isset($_POST['status_1']) ? intval($_POST['status_1']) : null;
$status_2 = isset($_POST['status_2']) ? intval($_POST['status_2']) : null;
$status_3 = isset($_POST['status_3']) ? intval($_POST['status_3']) : null;
$status_4 = isset($_POST['status_4']) ? intval($_POST['status_4']) : null;
$status_5 = isset($_POST['status_5']) ? intval($_POST['status_5']) : null;
$status_6 = isset($_POST['status_6']) ? intval($_POST['status_6']) : null;
$status_7 = isset($_POST['status_7']) ? intval($_POST['status_7']) : null;
$status_8 = isset($_POST['status_8']) ? intval($_POST['status_8']) : null;
$status_9 = isset($_POST['status_9']) ? intval($_POST['status_9']) : null;
$status_10 = isset($_POST['status_10']) ? intval($_POST['status_10']) : null;
$status_11 = isset($_POST['status_11']) ? intval($_POST['status_11']) : null;
$status_12 = isset($_POST['status_12']) ? intval($_POST['status_12']) : null;
$status_13 = isset($_POST['status_13']) ? intval($_POST['status_13']) : null;
$status_14 = isset($_POST['status_14']) ? $_POST['status_14'] : null; // varchar
$status_15 = isset($_POST['status_15']) ? intval($_POST['status_15']) : null;
$status_16 = isset($_POST['status_16']) ? intval($_POST['status_16']) : null;

// Set all_status_check to 1
$all_status_check = 1;

// Check for null values
if ($user_id === null || $status_1 === null || $status_2 === null || $status_3 === null || 
    $status_4 === null || $status_5 === null || $status_6 === null || $status_7 === null || 
    $status_8 === null || $status_9 === null || $status_10 === null || $status_11 === null || 
    $status_12 === null || $status_13 === null || $status_14 === null || $status_15 === null || 
    $status_16 === null) {
    die("Error: All fields must be filled.");
}

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO check_status (user_id, status_1, status_2, status_3, status_4, status_5, status_6, status_7, status_8, status_9, status_10, status_11, status_12, status_13, status_14, status_15, status_16, all_status_check) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("iiiiiiiiiiiiiiissi", $user_id, $status_1, $status_2, $status_3, $status_4, $status_5, $status_6, $status_7, $status_8, $status_9, $status_10, $status_11, $status_12, $status_13, $status_14, $status_15, $status_16, $all_status_check);

// Execute the statement
if ($stmt->execute()) {
    echo "New record created successfully";
} else {
    echo "Error: " . $stmt->error;
}

// Close connections
$stmt->close();
$conn->close();
?>
