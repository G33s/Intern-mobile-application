<?php
session_start();

// ตรวจสอบว่ามี session user_id และ username ถูกตั้งค่าอยู่หรือไม่
if (!isset($_SESSION['user_id']) || !isset($_SESSION['username'])) {
    header("Location: login.php"); // ถ้าไม่มีให้ redirect ไปที่หน้า login.php
    exit();
}

$user_id = $_SESSION['user_id'];
$username = $_SESSION['username'];
?>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <?php echo $username; ?>!</h2>
    <p>Login Successful.</p>
    <p><a href="logout.php">Logout</a></p>
</body>
</html>
