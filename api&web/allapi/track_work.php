<?php
// เปิดการแสดงข้อผิดพลาดสำหรับการดีบัก
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// เริ่มต้นตัวแปร
$result = [];
$message = '';
$showStatusFilter = false; // ตัวแปรเพื่อควบคุมการแสดง dropdown และปุ่มค้นหาครั้งที่สอง
$billcodes = []; // ตัวแปรสำหรับเก็บรหัสวางบิล
$profileName = ''; // ตัวแปรสำหรับเก็บชื่อโปรไฟล์

// การเชื่อมต่อฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("การเชื่อมต่อฐานข้อมูลล้มเหลว: " . $conn->connect_error);
}

// ดึงรหัสวางบิลทั้งหมดสำหรับ dropdown พร้อมชื่อผู้ใช้
$sql_billcodes = "SELECT DISTINCT u.bill_code, u.profile_name FROM users u";
$result_billcodes = $conn->query($sql_billcodes);

if ($result_billcodes->num_rows > 0) {
    while ($row = $result_billcodes->fetch_assoc()) {
        $billcodes[] = $row;
    }
}

// ตรวจสอบว่ามีการส่งฟอร์มหรือไม่
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $billcode = $_POST['billcode'];
    $status_filter = isset($_POST['status_filter']) ? $_POST['status_filter'] : ''; // รับค่า status_filter ถ้ามี

    // ตรวจสอบว่ากรอก billcode มาหรือไม่
    if (empty($billcode)) {
        $message = 'กรุณาเลือก รหัสวางบิล';
    } else {
        // ดึงชื่อโปรไฟล์สำหรับการแสดง
        $sql_profile = "SELECT DISTINCT u.profile_name FROM users u WHERE u.bill_code = ?";
        $stmt_profile = $conn->prepare($sql_profile);
        $stmt_profile->bind_param("s", $billcode);
        $stmt_profile->execute();
        $resultProfile = $stmt_profile->get_result();

        if ($resultProfile->num_rows > 0) {
            $profileData = $resultProfile->fetch_assoc();
            $profileName = $profileData['profile_name'];
        }

        // เตรียมคำสั่ง SQL เพื่อดึงข้อมูล
        $sql = "
            SELECT s.date_start, s.job_key, s.location_from_name, s.location_to_name,s.date_app_start,s.date_app_end, s.working_status
            FROM users u
            JOIN status s ON u.user_id = s.user_id
            WHERE u.bill_code = ?
        ";

        // ถ้ามีการเลือกสถานะ ให้เพิ่มเงื่อนไขในการกรองสถานะ
        if (!empty($status_filter)) {
            $sql .= " AND s.working_status = ?";
        }

        $stmt = $conn->prepare($sql);
        if ($stmt === false) {
            die("เกิดข้อผิดพลาดในการเตรียมคำสั่ง SQL: " . $conn->error);
        }

        // ผูกพารามิเตอร์และรันคำสั่ง
        if (!empty($status_filter)) {
            $stmt->bind_param("si", $billcode, $status_filter); // ถ้ามีสถานะ ให้ bind ด้วย
        } else {
            $stmt->bind_param("s", $billcode); // ถ้าไม่มีสถานะ ให้ bind แค่ billcode
        }
        $stmt->execute();

        $resultData = $stmt->get_result();

        if ($resultData->num_rows > 0) {
            // ดึงข้อมูลทั้งหมด
            $result = $resultData->fetch_all(MYSQLI_ASSOC);
            $showStatusFilter = true;
        } else {
            $message = "ไม่พบข้อมูลสำหรับ รหัสวางบิลนี้: " . htmlspecialchars($billcode);
        }

        $stmt->close();
        $stmt_profile->close();
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="th">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ติดตามงาน</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        h1 {
            color: #333;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            margin-right: 10px;
        }

        select {
            padding: 8px;
            width: 300px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        button {
            padding: 8px 16px;
            border: none;
            background-color: #28a745;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #218838;
        }

        .cancel-button {
            padding: 8px 16px;
            border: none;
            background-color: #dc3545;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

        .cancel-button:hover {
            background-color: #c82333;
        }

        .see-pic-button {
            padding: 8px 16px;
            border: none;
            background-color: #1bb439;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

        .see-pic-button:hover {
            background-color: #1bb439;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table,
        th,
        td {
            border: 1px solid #ccc;
        }

        th,
        td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f8f9fa;
        }

        .message {
            color: red;
            margin-top: 20px;
        }

        .form-container {
            margin-bottom: 20px;
        }

        .back-button {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .info-box {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f8f9fa;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmCancel(jobKey) {
            Swal.fire({
                title: 'ยืนยันการยกเลิก?',
                text: 'คุณต้องการยกเลิกงานนี้หรือไม่?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'ยืนยัน',
                cancelButtonText: 'ยกเลิก'
            }).then((result) => {
                if (result.isConfirmed) {
                    var form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'cancel_job.php';
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'job_key';
                    input.value = jobKey;
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }

        function viewImage(jobKey) {
            // Perform an AJAX request to fetch the image URL
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "http://localhost/allapi/view_images.php", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function () {
                if (xhr.status === 200) {
                    // Parse the response
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        // Open the image in a new tab
                        window.open(response.imageUrl, '_blank');
                    } else {
                        // Use SweetAlert to show error message
                        Swal.fire({
                            icon: 'error',
                            title: 'ไม่พบรูปภาพ',
                            text: 'ไม่พบรูปภาพสำหรับงานนี้.',
                            confirmButtonText: 'ตกลง',
                        });
                    }
                } else {
                    // Use SweetAlert to show error message
                    Swal.fire({
                        icon: 'error',
                        title: 'เกิดข้อผิดพลาด',
                        text: 'เกิดข้อผิดพลาดในการดึงข้อมูลรูปภาพ.',
                        confirmButtonText: 'ตกลง',
                    });
                }
            };
            xhr.send("job_key=" + encodeURIComponent(jobKey));
        }


        function showSuccessAlert() {
            Swal.fire({
                title: 'สำเร็จ!',
                text: 'การยกเลิกงานเสร็จสิ้น.',
                icon: 'success',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'ตกลง'
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('cancel_success')) {
                showSuccessAlert();
            }
        });
    </script>

</head>

<body>
    <h1>ติดตามงาน</h1>

    <a href="main_menu.html" class="back-button">กลับหน้าหลัก</a>

    <div class="form-container">
        <form method="POST" action="track_work.php">
            <label for="billcode">เลือก รหัสวางบิล:</label>
            <select id="billcode" name="billcode" required>
                <option value="">เลือก...</option>
                <?php foreach ($billcodes as $item): ?>
                    <option value="<?php echo htmlspecialchars($item['bill_code']); ?>">
                        <?php echo htmlspecialchars($item['bill_code']) . ' - ' . htmlspecialchars($item['profile_name']); ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <button type="submit">ค้นหา</button>
        </form>

        <?php if ($showStatusFilter): ?>
            <form method="POST" action="track_work.php">
                <input type="hidden" name="billcode" value="<?php echo htmlspecialchars($billcode); ?>">
                <label for="status_filter">กรองตามสถานะ:</label>
                <select id="status_filter" name="status_filter">
                    <option value="">ทั้งหมด</option>
                    <option value="1" <?php echo ($status_filter == '1') ? 'selected' : ''; ?>>ยังไม่เริ่มงาน</option>
                    <option value="2" <?php echo ($status_filter == '2') ? 'selected' : ''; ?>>งานที่เสร็จสิ้น</option>
                    <option value="3" <?php echo ($status_filter == '3') ? 'selected' : ''; ?>>งานที่อยู่ระหว่างขนส่ง</option>
                    <option value="4" <?php echo ($status_filter == '4') ? 'selected' : ''; ?>>งานที่ยกเลิก</option>
                </select>
                <button type="submit">ค้นหาเพิ่มเติม</button>
            </form>
        <?php endif; ?>
    </div>

    <?php if ($showStatusFilter): ?>
        <div class="info-box">
            <p><strong>ชื่อโปรไฟล์:</strong> <?php echo htmlspecialchars($profileName); ?></p>
            <p><strong>รหัสวางบิล:</strong> <?php echo htmlspecialchars($billcode); ?></p>
        </div>
    <?php endif; ?>

    <?php if (count($result) > 0): ?>
        <table>
            <thead>
                <tr>
                    <th>วันที่เริ่มงาน</th>
                    <th>รหัสงาน</th>
                    <th>จากที่</th>
                    <th>ถึงที่</th>
                    <th>เวลาเริ่มงาน</th>
                    <th>เวลาจบงาน</th>
                    <th>สถานะการทำงาน</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($result as $row): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($row['date_start']); ?></td>
                        <td><?php echo htmlspecialchars($row['job_key']); ?></td>
                        <td><?php echo htmlspecialchars($row['location_from_name']); ?></td>
                        <td><?php echo htmlspecialchars($row['location_to_name']); ?></td>
                        <td>
                            <?php echo !empty($row['date_app_start']) ? htmlspecialchars($row['date_app_start']) : '----'; ?>
                        </td>
                        <td>
                            <?php echo !empty($row['date_app_end']) ? htmlspecialchars($row['date_app_end']) : '----'; ?>
                        </td>
                        <td>
                            <?php
                            switch ($row['working_status']) {
                                case 1:
                                    echo "ยังไม่เริ่มงาน";
                                    break;
                                case 2:
                                    echo "เสร็จสิ้น";
                                    break;
                                case 3:
                                    echo "อยู่ระหว่างขนส่ง";
                                    break;
                                case 4:
                                    echo "ยกเลิก";
                                    break;
                                default:
                                    echo "สถานะไม่ทราบ";
                            }
                            ?>
                            <?php if ($row['working_status'] == 3 || $row['working_status'] == '1'): ?>
                                <button type="button" class="cancel-button"
                                    onclick="confirmCancel('<?php echo htmlspecialchars($row['job_key']); ?>')">ยกเลิก</button>
                            <?php endif; ?>
                            <?php if ($row['working_status'] == 2): ?>
                                <button type="button" class="see-pic-button"
                                    onclick="viewImage('<?php echo htmlspecialchars($row['job_key']); ?>')">ดูรูปภาพ</button>
                            <?php endif; ?>

                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php elseif (!empty($message)): ?>
        <p class="message"><?php echo $message; ?></p>
    <?php endif; ?>
</body>

</html>