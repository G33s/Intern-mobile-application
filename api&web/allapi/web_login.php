<?php
session_start();
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER["REQUEST_METHOD"] == "POST" && !empty($data['username']) && !empty($data['password'])) {
    $inputUsername = $data['username'];
    $inputPassword = $data['password'];

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        echo json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]);
        exit();
    }

    // ปรับปรุง query เพื่อเช็ค web_permission
    $sql = "SELECT user_id, username, web_permission FROM users WHERE username = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $inputUsername, $inputPassword);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($user_id, $username, $web_permission);
        $stmt->fetch();

        // เช็คว่า web_permission เป็น 1 หรือไม่
        if ($web_permission == 1) {
            $_SESSION['user_id'] = $user_id;
            $_SESSION['username'] = $username;
            echo json_encode(["success" => true, "message" => "เข้าสู่ระบบสำเร็จ", "user_id" => $user_id, "username" => $username]);
        } else {
            echo json_encode(["success" => false, "message" => "ไม่มีสิทธ์ในการใช้งาน"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Username หรือ Password ผิด"]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
?>
