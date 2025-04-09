<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $bill_code = $_POST['bill_code'];
    $new_password = $_POST['new_password'];
    $confirm_password = $_POST['confirm_password'];

    if ($new_password === $confirm_password) {
        // ทำการอัปเดตรหัสผ่านในฐานข้อมูล
        $sql = "UPDATE users SET password = ? WHERE bill_code = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ss", $new_password, $bill_code);
        if ($stmt->execute()) {
            echo "<!DOCTYPE html>
            <html lang='en'>
            <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>Update Password</title>
                <script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>
            </head>
            <body>
                <script>
                    Swal.fire({
                        title: 'สำเร็จ!',
                        text: 'อัพเดตรหัสผ่านเรียบร้อยแล้ว',
                        icon: 'success',
                        confirmButtonText: 'ตกลง'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = 'main_menu.html';
                        }
                    });
                </script>
            </body>
            </html>";
        } else {
            echo "<!DOCTYPE html>
            <html lang='en'>
            <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>Update Password</title>
                <script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>
            </head>
            <body>
                <script>
                    Swal.fire({
                        title: 'ผิดพลาด!',
                        text: 'ไม่สามารถอัพเดตรหัสผ่านได้',
                        icon: 'error',
                        confirmButtonText: 'ตกลง'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = 'reset_new_password.html?bill_code=' + encodeURIComponent('$bill_code');
                        }
                    });
                </script>
            </body>
            </html>";
        }
        $stmt->close();
    } else {
        echo "<!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta charset='UTF-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>
            <title>Update Password</title>
            <script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>
        </head>
        <body>
            <script>
                Swal.fire({
                    title: 'ผิดพลาด!',
                    text: 'รหัสผ่านใหม่และการยืนยันรหัสผ่านไม่ตรงกัน',
                    icon: 'error',
                    confirmButtonText: 'ตกลง'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'reset_new_password.html?bill_code=' + encodeURIComponent('$bill_code');
                    }
                });
            </script>
        </body>
        </html>";
    }
}

$conn->close();
?>
