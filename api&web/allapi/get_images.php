<?php
// ตั้งค่าการเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "news_db";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// ดึงข้อมูลจากตาราง images
$sql = "SELECT file_name, file_path FROM images";
$result = $conn->query($sql);

$images = array();

if ($result->num_rows > 0) {
    // เก็บข้อมูลที่ดึงได้ลงใน array
    while($row = $result->fetch_assoc()) {
        $images[] = $row;
    }
}

// ส่งข้อมูลกลับเป็น JSON
header('Content-Type: application/json');
echo json_encode($images);

$conn->close();
?>
