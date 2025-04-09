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

// Get user_id from the query parameters
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

// SQL query to fetch the required fields from the status table, including date_start
$sql = "SELECT 
            job_key, 
            location_from_name, 
            from_province_name,
            from_district_name,
            from_sub_district_name,
            location_to_name, 
            to_province_name,
            to_district_name,
            to_sub_district_name,
            contact_number,
            working_status,
            date,
            date_start,
            date_app_start,
            date_app_end
        FROM status 
        WHERE user_id = ?";

$stmt = $conn->prepare($sql);

// Check if statement preparation was successful
if ($stmt === false) {
    echo json_encode(['error' => 'Prepare statement failed: ' . $conn->error]);
    exit();
}

// Bind the parameters and execute the query
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// Check if the query execution was successful
if ($result === false) {
    echo json_encode(['error' => 'Query execution failed: ' . $stmt->error]);
    exit();
}

// Fetch all the results into an array
$jobs = [];
while ($row = $result->fetch_assoc()) {
    $jobs[] = $row;
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Output the results as a JSON array
echo json_encode($jobs);
?>
