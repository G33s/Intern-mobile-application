<?php
// Connect to the database
$servername = "localhost";
$db_username = "root"; // Replace with your database username
$db_password = ""; // Replace with your database password
$dbname = "account_inform";

$conn = new mysqli($servername, $db_username, $db_password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the form data
$user = $_POST['username'];
$bill_code = $_POST['bill_code'];

// Prevent SQL injection
$user = $conn->real_escape_string($user);
$bill_code = $conn->real_escape_string($bill_code);

// Check if the username and bill_code exist
$sql = "SELECT * FROM users WHERE username='$user' AND bill_code='$bill_code'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Redirect to the reset password form with query parameters
    header("Location: reset_new_password.php?username=$user&bill_code=$bill_code");
    exit();
} else {
    echo "<script>alert('Username หรือ รหัสวางบิล ไม่ถูกต้อง'); window.location.href='reset_password.html';</script>";
}

$conn->close();
?>
