<?php
// เปิดการแสดงข้อผิดพลาดสำหรับการดีบัก
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// การเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("การเชื่อมต่อฐานข้อมูลล้มเหลว: " . $conn->connect_error);
}

// ตรวจสอบว่ามีการส่ง job_key มาหรือไม่
if (isset($_POST['job_key'])) {
    $job_key = $_POST['job_key'];

    // คำสั่ง SQL เพื่ออัปเดตสถานะงานเป็นยกเลิก
    $sql = "UPDATE status SET working_status = 4 WHERE job_key = ?";

    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        die("เกิดข้อผิดพลาดในการเตรียมคำสั่ง SQL: " . $conn->error);
    }

    // ผูกพารามิเตอร์และรันคำสั่ง
    $stmt->bind_param("s", $job_key);
    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            // ถ้ามีการอัปเดตสำเร็จ
            header("Location: track_work.php?cancel_success=1");
            exit();
        } else {
            // ถ้าไม่พบงานที่ต้องการยกเลิก
            header("Location: track_work.php?cancel_success=0&message=ไม่พบงานที่ต้องการยกเลิก");
            exit();
        }
    } else {
        // ถ้าเกิดข้อผิดพลาดในการอัปเดตสถานะ
        header("Location: track_work.php?cancel_success=0&message=เกิดข้อผิดพลาดในการอัปเดตสถานะงาน");
        exit();
    }


} else {
    // ถ้าไม่มีรหัสงานที่ระบุ
    header("Location: track_work.php?cancel_success=0&message=ไม่มีรหัสงานที่ระบุ");
    exit();
}
?>
