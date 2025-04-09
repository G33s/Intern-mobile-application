<?php
// ตรวจสอบว่า user_id ถูกส่งมาหรือไม่
if (!isset($_GET['user_id']) || !is_numeric($_GET['user_id'])) {
    echo json_encode(['error' => 'Invalid or missing user_id']);
    exit;
}

header('Content-Type: application/json');

// ข้อมูลเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "car_status";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$user_id = $_GET['user_id'];

// ดึงข้อมูล all_status_check ของวันนี้
$query = "SELECT all_status_check FROM check_status WHERE user_id = ? AND DATE(check_time) = CURDATE() LIMIT 1";
$stmt = $conn->prepare($query);

if ($stmt === false) {
    echo json_encode(["error" => "Failed to prepare statement: " . $conn->error]);
    $conn->close();
    exit;
}

$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode($row);
} else {
    echo json_encode(['all_status_check' => 0]);
}

// ปิด statement และการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
