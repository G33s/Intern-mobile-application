<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "app";

// Database connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Only proceed if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // Get the data from POST
    $user_id = $_POST['user_id'];
    $job_key = $_POST['job_key'];

    // Validate inputs
    if (!isset($_FILES['image']) || empty($user_id) || empty($job_key)) {
        die("Invalid input data");
    }

    // Handle the file upload
    $target_dir = "uploads/";
    $file_name = basename($_FILES["image"]["name"]);
    $target_file = $target_dir . $file_name;

    // Ensure the file has been uploaded without errors
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {

        // Insert the image path into the database
        $stmt = $conn->prepare("INSERT INTO job_images (user_id, job_key, image_path) VALUES (?, ?, ?)");
        $stmt->bind_param("iss", $user_id, $job_key, $target_file);

        if ($stmt->execute()) {
            echo "Image uploaded and saved to database successfully.";
        } else {
            echo "Database error: " . $stmt->error;
        }

        $stmt->close();
    } else {
        echo "Error uploading file.";
    }

    $conn->close();
} else {
    echo "Invalid request method.";
}
?>
