<?php
header('Content-Type: application/json');

// เปิดการแสดงข้อผิดพลาด
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// กำหนดค่าตัวแปรฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    echo json_encode(['error' => 'Database connection failed: ' . $conn->connect_error]);
    exit();
}

// รับ job_key จากพารามิเตอร์ GET
$job_key = isset($_GET['job_key']) ? $_GET['job_key'] : '';

// คำสั่ง SQL เพื่อดึงข้อมูลรายละเอียดงาน
$sql = "SELECT 
            job_key, 
            location_from_name, 
            from_province_name, 
            from_district_name, 
            from_sub_district_name, 
            from_post_code, 
            from_building_number,
            location_to_name, 
            to_province_name, 
            to_district_name, 
            to_sub_district_name, 
            to_post_code, 
            to_building_number,
            contact_number,
            date
        FROM status
        WHERE job_key = ?";

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    echo json_encode(['error' => 'Prepare statement failed: ' . $conn->error]);
    exit();
}

// การใช้ "s" แทน "i" เพราะ job_key เป็น varchar
$stmt->bind_param("s", $job_key);
$stmt->execute();
$result = $stmt->get_result();

if ($result === false) {
    echo json_encode(['error' => 'Query execution failed: ' . $stmt->error]);
    exit();
}

$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

$stmt->close();
$conn->close();

// ส่งข้อมูลในรูปแบบ JSON array
echo json_encode($jobs);
?>
