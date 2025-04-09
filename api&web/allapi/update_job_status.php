<?php
header("Content-Type: application/json");

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Connection failed: " . $e->getMessage()]);
    exit;
}

// Read the input data from the Flutter app
$input = json_decode(file_get_contents("php://input"), true);

$userId = isset($input['user_id']) ? $input['user_id'] : null;
$jobKey = isset($input['job_key']) ? $input['job_key'] : null;
$workingStatus = isset($input['working_status']) ? $input['working_status'] : null;

if ($userId && $jobKey && $workingStatus !== null) {
    try {
        // Check if working_status is 2, then update both date_app_start and date_app_end
        if ($workingStatus == 2) {
            $stmt = $pdo->prepare("
                UPDATE status 
                SET working_status = :working_status, 
                    date_app_end = CURRENT_TIMESTAMP
                WHERE user_id = :user_id 
                  AND job_key = :job_key
            ");
        } else {
            // Update only working_status and date_app_start for other statuses
            $stmt = $pdo->prepare("
                UPDATE status 
                SET working_status = :working_status, 
                    date_app_start = CURRENT_TIMESTAMP
                WHERE user_id = :user_id 
                  AND job_key = :job_key
            ");
        }

        $stmt->bindParam(':working_status', $workingStatus, PDO::PARAM_INT);
        $stmt->bindParam(':job_key', $jobKey, PDO::PARAM_STR);
        $stmt->bindParam(':user_id', $userId, PDO::PARAM_INT);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Job status and dates updated successfully."]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update job status."]);
        }
    } catch (PDOException $e) {
        echo json_encode(["success" => false, "message" => "Query error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid input data."]);
}
?>
