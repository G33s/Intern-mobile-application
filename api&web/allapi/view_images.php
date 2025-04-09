<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "app";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['job_key'])) {
    $job_key = trim($conn->real_escape_string($_POST['job_key']));
    $stmt = $conn->prepare("SELECT image_path FROM job_images WHERE job_key = ?");
    
    if ($stmt) {
        $stmt->bind_param("s", $job_key);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $images = [];
            while ($row = $result->fetch_assoc()) {
                $images[] = htmlspecialchars($row['image_path']);
            }
            echo json_encode(["success" => true, "imageUrl" => $images[0]]); // Return the first image path
        } else {
            echo json_encode(["success" => false, "message" => "ไม่พบรูปภาพสำหรับงานนี้."]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "เกิดข้อผิดพลาดในการเตรียมคำสั่ง SQL."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "ข้อมูลไม่ถูกต้อง."]);
}

$conn->close();
?>
