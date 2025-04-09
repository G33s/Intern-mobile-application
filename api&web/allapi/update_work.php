<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Work</title>
    <!-- Include SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// ฟังก์ชันสร้างรหัสงานแบบสุ่ม
function generateJobKey() {
    $letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomLetters = substr(str_shuffle($letters), 0, 3);
    $randomDigits = substr(str_shuffle('0123456789'), 0, 5);
    return $randomLetters . '-' . $randomDigits;
}

// ตรวจสอบว่าฟอร์มถูกส่งมาหรือไม่ และตรวจสอบค่าว่างของฟิลด์
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (!empty($_POST['bill_code']) && !empty($_POST['location_from_name']) && !empty($_POST['from_province_name']) && !empty($_POST['from_district_name']) && !empty($_POST['from_sub_district_name']) && !empty($_POST['from_post_code']) && !empty($_POST['from_building_number']) && !empty($_POST['location_to_name']) && !empty($_POST['to_province_name']) && !empty($_POST['to_district_name']) && !empty($_POST['to_sub_district_name']) && !empty($_POST['to_post_code']) && !empty($_POST['to_building_number']) && !empty($_POST['contact_number']) && !empty($_POST['date_start'])) {

        // รับข้อมูลจากฟอร์ม
        $bill_code = $_POST['bill_code'];
        $job_key = generateJobKey(); 
        $location_from_name = $_POST['location_from_name'];
        $from_province_name = $_POST['from_province_name'];
        $from_district_name = $_POST['from_district_name'];
        $from_sub_district_name = $_POST['from_sub_district_name'];
        $from_post_code = $_POST['from_post_code'];
        $from_building_number = $_POST['from_building_number'];
        $location_to_name = $_POST['location_to_name'];
        $to_province_name = $_POST['to_province_name'];
        $to_district_name = $_POST['to_district_name'];
        $to_sub_district_name = $_POST['to_sub_district_name'];
        $to_post_code = $_POST['to_post_code'];
        $to_building_number = $_POST['to_building_number'];
        $contact_number = $_POST['contact_number'];
        $date_start = $_POST['date_start']; 
        
        // กำหนดค่า working_status
        $working_status = 1;

        // ตรวจสอบ bill_code เพื่อค้นหา user_id
        $sql_user = $conn->prepare("SELECT user_id FROM users WHERE bill_code = ?");
        $sql_user->bind_param('s', $bill_code);
        $sql_user->execute();
        $result_user = $sql_user->get_result();

        if ($result_user->num_rows > 0) {
            $user_id = $result_user->fetch_assoc()['user_id'];

            // ตรวจสอบว่า job_key มีอยู่ในฐานข้อมูลแล้วหรือไม่
            $sql_check = $conn->prepare("SELECT * FROM status WHERE job_key = ?");
            $sql_check->bind_param('s', $job_key);
            $sql_check->execute();
            $result_check = $sql_check->get_result();

            if ($result_check->num_rows > 0) {
                // job_key มีอยู่แล้ว
                echo "<script>
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'job_key นี้มีอยู่แล้ว',
                            confirmButtonText: 'ตกลง'
                        }).then(function() {
                            window.location.href='send_work.html';
                        });
                    </script>";
            } else {
                // เพิ่มข้อมูลใหม่ลงในตาราง status
                $sql_insert = $conn->prepare("
                    INSERT INTO status (user_id, job_key, location_from_name, from_province_name, from_district_name, from_sub_district_name, from_post_code, from_building_number, location_to_name, to_province_name, to_district_name, to_sub_district_name, to_post_code, to_building_number, contact_number, `date_start`, `date`, working_status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)
                ");
                $sql_insert->bind_param(
                    'isssssssssssssssi',
                    $user_id, $job_key, $location_from_name, $from_province_name, $from_district_name, $from_sub_district_name, $from_post_code, $from_building_number,
                    $location_to_name, $to_province_name, $to_district_name, $to_sub_district_name, $to_post_code, $to_building_number, $contact_number, $date_start, $working_status
                );

                if ($sql_insert->execute()) {
                    // เพิ่มข้อความแจ้งเตือน
                    $notification_message = "รหัสงาน: $job_key";
                    $sql_notification = $conn->prepare("INSERT INTO notifications (user_id, message, date) VALUES (?, ?, NOW())");
                    $sql_notification->bind_param('is', $user_id, $notification_message);
                    $sql_notification->execute();

                    echo "<script>
                            Swal.fire({
                                icon: 'success',
                                title: 'สำเร็จ',
                                text: 'งานถูกบันทึกเรียบร้อยแล้ว',
                                confirmButtonText: 'ตกลง'
                            }).then(function() {
                                window.location.href='main_menu.html';
                            });
                        </script>";
                } else {
                    echo "<script>
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Error adding record: " . $conn->error . "',
                                confirmButtonText: 'ตกลง'
                            }).then(function() {
                                window.location.href='send_work.html';
                            });
                        </script>";
                }
            }
        } else {
            // bill_code ไม่ตรงกับผู้ใช้ใด
            echo "<script>
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'รหัสวางบิลนี้ไม่ตรงกับผู้ใช้ใด',
                        confirmButtonText: 'ตกลง'
                    }).then(function() {
                        window.location.href='send_work.html';
                    });
                </script>";
        }
    } else {
        // มีฟิลด์ใดฟิลด์หนึ่งว่าง
        echo "<script>
                Swal.fire({
                    icon: 'warning',
                    title: 'กรุณากรอกข้อมูลให้ครบถ้วน',
                    confirmButtonText: 'ตกลง'
                }).then(function() {
                    window.location.href='send_work.html';
                });
            </script>";
    }
}

$conn->close();
?>

</body>
</html>
