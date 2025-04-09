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

// ตรวจสอบว่ามีข้อมูลถูกส่งมาจากฟอร์มหรือไม่
$selected_user = null;
if ($_SERVER["REQUEST_METHOD"] == "POST" && !empty($_POST['user_info'])) {
    $selected_bill_code = $_POST['user_info'];

    // ดึงข้อมูลผู้ใช้จากตาราง users โดยใช้ bill_code ที่ผู้ใช้เลือก
    $sql = "SELECT profile_name, bill_code, phone, car_type, car_regis, regis_province, car_brand, tank_number, department_leader, department_phone, branch 
            FROM users WHERE bill_code = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $selected_bill_code);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $selected_user = $result->fetch_assoc();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ข้อมูลผู้ใช้</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .back-button {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: #007BFF;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 500px;
            padding: 20px;
            margin-top: 20px;
            text-align: center;
        }

        h2 {
            color: #333;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            color: #555;
        }

        select {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background-color: #007BFF;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }

        button:hover {
            background-color: #0056b3;
        }

        .user-info {
            margin-top: 20px;
            text-align: left;
        }

        .user-info p {
            font-size: 16px;
            margin: 5px 0;
        }

        .user-info p strong {
            color: #333;
        }

        .error-message {
            color: red;
            font-weight: bold;
        }

        .button-group {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <!-- ปุ่มกลับหน้าหลักจะอยู่ด้านซ้ายบน -->
    <button class="back-button" onclick="location.href='main_menu.html'">กลับหน้าหลัก</button>

    <div class="container">
        <h2>เลือกผู้ใช้เพื่อดูข้อมูล</h2>
        <form method="POST" action="">
            <label for="user_info">เลือกผู้ใช้:</label>
            <select name="user_info" id="user_info">
                <option value="">-- เลือกผู้ใช้ --</option>
                <?php
                // ดึงข้อมูล bill_code และ profile_name จากตาราง users เพื่อแสดงใน dropdown
                $sql_users = "SELECT bill_code, profile_name FROM users";
                $result_users = $conn->query($sql_users);

                if ($result_users->num_rows > 0) {
                    while ($row = $result_users->fetch_assoc()) {
                        echo "<option value='" . $row['bill_code'] . "'>" . $row['bill_code'] . " - " . $row['profile_name'] . "</option>";
                    }
                } else {
                    echo "<option value=''>ไม่พบผู้ใช้</option>";
                }
                ?>
            </select>
            <button type="submit">ดูข้อมูล</button>
        </form>

        <?php if ($selected_user): ?>
            <div class="user-info">
                <h3>ข้อมูลผู้ใช้</h3>
                <p><strong>ชื่อผู้ใช้:</strong> <?php echo $selected_user['profile_name']; ?></p>
                <p><strong>รหัสวางบิล:</strong> <?php echo $selected_user['bill_code']; ?></p>
                <p><strong>เบอร์โทร:</strong> <?php echo $selected_user['phone']; ?></p>
                <p><strong>ประเภทรถ:</strong> <?php echo $selected_user['car_type']; ?></p>
                <p><strong>ทะเบียนรถ:</strong> <?php echo $selected_user['car_regis']; ?></p>
                <p><strong>จังหวัดที่จดทะเบียน:</strong> <?php echo $selected_user['regis_province']; ?></p>
                <p><strong>ยี่ห้อรถ:</strong> <?php echo $selected_user['car_brand']; ?></p>
                <p><strong>หมายเลขถัง:</strong> <?php echo $selected_user['tank_number']; ?></p>
                <p><strong>หัวหน้าแผนก:</strong> <?php echo $selected_user['department_leader']; ?></p>
                <p><strong>เบอร์หัวหน้าแผนก:</strong> <?php echo $selected_user['department_phone']; ?></p>
                <p><strong>สาขา:</strong> <?php echo $selected_user['branch']; ?></p>
            </div>
            <div class="button-group">
                <button onclick="location.href='reset_new_password.html?bill_code=<?php echo $selected_user['bill_code']; ?>'">อัพเดตรหัสผ่าน</button>
            </div>
        <?php elseif ($_SERVER["REQUEST_METHOD"] == "POST"): ?>
            <p class="error-message">ไม่พบข้อมูลผู้ใช้สำหรับ รหัสวางบิล นี้</p>
        <?php endif; ?>

        <!-- ปุ่มเพิ่มพนักงาน -->
        <div class="button-group">
            <button onclick="location.href='add_employee.php'">เพิ่มพนักงาน</button>
        </div>

    </div>

</body>
</html>

<?php
$conn->close();
?>
