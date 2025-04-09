<?php
// เชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("การเชื่อมต่อล้มเหลว: " . $conn->connect_error);
}

// รับข้อมูลจากฟอร์ม
$profile_name = $_POST['profile_name'];
$username = $_POST['username'];
$password = $_POST['password'];
$bill_code = $_POST['bill_code'];
$phone = $_POST['phone'];
$car_type = $_POST['car_type'];
$car_regis = $_POST['car_regis'];
$regis_province = $_POST['regis_province'];
$car_brand = $_POST['car_brand'];
$tank_number = $_POST['tank_number'];
$department_leader = $_POST['department_leader'];
$department_phone = $_POST['department_phone'];
$branch = $_POST['branch'];
$web_permission = $_POST['web_permission'];

// ตรวจสอบว่ารหัสบิลซ้ำหรือไม่
$sql_check_bill = "SELECT COUNT(*) AS count FROM users WHERE bill_code = ?";
$stmt_check_bill = $conn->prepare($sql_check_bill);
$stmt_check_bill->bind_param("s", $bill_code);
$stmt_check_bill->execute();
$result_check_bill = $stmt_check_bill->get_result();
$row_bill = $result_check_bill->fetch_assoc();

// ตรวจสอบว่า username ซ้ำหรือไม่
$sql_check_username = "SELECT COUNT(*) AS count FROM users WHERE username = ?";
$stmt_check_username = $conn->prepare($sql_check_username);
$stmt_check_username->bind_param("s", $username);
$stmt_check_username->execute();
$result_check_username = $stmt_check_username->get_result();
$row_username = $result_check_username->fetch_assoc();

// ตรวจสอบผลลัพธ์
if ($row_bill['count'] > 0) {
    // รหัสบิลซ้ำ
    header("Location: add_employee.php?status=error_billcode");
} elseif ($row_username['count'] > 0) {
    // ชื่อผู้ใช้ซ้ำ
    header("Location: add_employee.php?status=error_username");
} else {
    // สร้างคำสั่ง SQL
    $sql = "INSERT INTO users (profile_name, username, password, bill_code, phone, car_type, car_regis, regis_province, car_brand, tank_number, department_leader, department_phone, branch, web_permission) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    // เตรียมคำสั่ง SQL และผูกพารามิเตอร์
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssssssssssss", $profile_name, $username, $password, $bill_code, $phone, $car_type, $car_regis, $regis_province, $car_brand, $tank_number, $department_leader, $department_phone, $branch, $web_permission);

    // ตรวจสอบการดำเนินการคำสั่ง SQL
    if ($stmt->execute()) {
        header("Location: add_employee.php?status=success"); // การเพิ่มข้อมูลสำเร็จ
    } else {
        header("Location: add_employee.php?status=error"); // การเพิ่มข้อมูลล้มเหลว
    }
}

// ปิดการเชื่อมต่อ
$stmt->close();
$stmt_check_bill->close();
$stmt_check_username->close();
$conn->close();
?>
