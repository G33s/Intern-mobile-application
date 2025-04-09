<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    echo json_encode(['error' => 'Database connection failed: ' . $conn->connect_error]);
    exit();
}

// Get job_key from the query parameters
$job_key = isset($_GET['job_key']) ? $_GET['job_key'] : '';

// SQL query to fetch the required job details
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
            working_status, 
            date_start, 
            date_app_start, 
            date_app_end 
        FROM status 
        WHERE job_key = ?";

$stmt = $conn->prepare($sql);

// Check if statement preparation was successful
if ($stmt === false) {
    echo json_encode(['error' => 'Prepare statement failed: ' . $conn->error]);
    exit();
}

// Bind the parameters and execute the query
$stmt->bind_param("s", $job_key);
$stmt->execute();
$result = $stmt->get_result();

// Check if the query execution was successful
if ($result === false) {
    echo json_encode(['error' => 'Query execution failed: ' . $stmt->error]);
    exit();
}

// Fetch the result
$job_detail = $result->fetch_assoc();

// Close the statement and connection
$stmt->close();
$conn->close();

// Output the result as JSON
echo json_encode($job_detail);
?>
