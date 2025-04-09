<?php
header('Content-Type: application/json');

$user_id = $_GET['user_id'];

// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Prepare and execute the SQL query
$sql = "SELECT profile_name, 
               bill_code,
               phone, 
               car_type, 
               car_regis, 
               regis_province, 
               car_brand,
               tank_number, 
               department_leader, 
               department_phone, 
               branch 
        FROM users 
        WHERE user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode([
        'success' => true,
        'profile_name' => $row['profile_name'],
        'phone' => $row['phone'],
        'bill_code' => $row['bill_code'],
        'car_type' => $row['car_type'],
        'car_regis' => $row['car_regis'],
        'regis_province' => $row['regis_province'],
        'car_brand' => $row['car_brand'],
        'tank_number' => $row['tank_number'],
        'department_leader' => $row['department_leader'],
        'department_phone' => $row['department_phone'],
        'branch' => $row['branch']
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'No user found']);
}

$stmt->close();
$conn->close();
?>
