<?php
// การเชื่อมต่อกับฐานข้อมูล
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "account_inform";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add to Database</title>
    <link rel="stylesheet" href="styles_sendwork.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
    <button class="home-button" onclick="location.href='main_menu.html'">หน้าหลัก</button>

    <form id="dataForm" action="update_work.php" method="post">
        <!-- Dropdown รหัสวางบิล -->
        <label for="bill_code">รหัสวางบิล:</label>
        <select id="bill_code" name="bill_code" required>
            <option value="">เลือก รหัสวางบิล</option>
            <?php
            // ดึงข้อมูลจากตาราง users
            $sql = "SELECT bill_code, profile_name FROM users";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo "<option value='" . $row['bill_code'] . "'>" . $row['bill_code'] . " - " . $row['profile_name'] . "</option>";
                }
            }
            ?>
        </select>

        <!-- ฟอร์มสำหรับส่งจาก -->
        <label for="location_from_name">ส่งจาก:</label>
        <input type="text" id="location_from_name" name="location_from_name" required>

        <label for="date_start">วันที่เริ่มต้น:</label>
        <input type="date" id="date_start" name="date_start" required>

        <label for="from_province_name">จังหวัด:</label>
        <select id="from_province_name" name="from_province_name" required>
            <option value="">เลือกจังหวัด</option>
            <option value="กรุงเพพ">กรุงเพพ</option>
            <option value="เชียงใหม่">เชียงใหม่</option>
            <option value="ชลบุรี">ชลบุรี</option>
        </select>

        <label for="from_district_name">เขต/อำเภอ:</label>
        <select id="from_district_name" name="from_district_name" required>
            <option value="">เลือก เขต/อำเภอ</option>
            <option value="ดินแดง">ดินแดง</option>
            <option value="เมืองเชียงใหม่">เมืองเชียงใหม่</option>
            <option value="บางแสน">บางแสน</option>
        </select>

        <label for="from_sub_district_name">ตำบล/แขวง:</label>
        <select id="from_sub_district_name" name="from_sub_district_name" required>
            <option value="---">---</option>
            <option value="ดินแดง">ดินแดง</option>
            <option value="ช้างเผือก">ช้างเผือก</option>
            <option value="แสนสุข">แสนสุข</option>
        </select>

        <label for="from_post_code">รหัสไปรษณีย์:</label>
        <input type="text" id="from_post_code" name="from_post_code" required>

        <label for="from_building_number">เลขที่อยู่:</label>
        <input type="text" id="from_building_number" name="from_building_number" required>


        <!-- ฟอร์มสำหรับส่งไปที่ -->
        <label for="location_to_name">ส่งไปที่:</label>
        <input type="text" id="location_to_name" name="location_to_name" required>

        <label for="to_province_name">จังหวัด:</label>
        <select id="to_province_name" name="to_province_name" required>
            <option value="">เลือกจังหวัด</option>
            <option value="กรุงเพพ">กรุงเพพ</option>
            <option value="เชียงใหม่">เชียงใหม่</option>
            <option value="ชลบุรี">ชลบุรี</option>
        </select>

        <label for="to_district_name">เขต/อำเภอ:</label>
        <select id="to_district_name" name="to_district_name" required>
            <option value="">เลือก เขต/อำเภอ</option>
            <option value="ดินแดง">ดินแดง</option>
            <option value="เมืองเชียงใหม่">เมืองเชียงใหม่</option>
            <option value="บางแสน">บางแสน</option>
        </select>

        <label for="to_sub_district_name">ตำบล/แขวง:</label>
        <select id="to_sub_district_name" name="to_sub_district_name" required>
            <option value="---">---</option>
            <option value="ดินแดง">ดินแดง</option>
            <option value="ช้างเผือก">ช้างเผือก</option>
            <option value="แสนสุข">แสนสุข</option>
        </select>

        <label for="to_post_code">รหัสไปรษณีย์:</label>
        <input type="text" id="to_post_code" name="to_post_code" required>

        <label for="to_building_number">เลขที่อยู่:</label>
        <input type="text" id="to_building_number" name="to_building_number" required>

        <label for="contact_number">เบอร์ติดต่อ:</label>
        <input type="text" id="contact_number" name="contact_number" maxlength="10" required>

        <input type="submit" value="ยืนยัน">
    </form>

    <script>
        document.getElementById('dataForm').addEventListener('submit', function (event) {
            event.preventDefault(); // Prevent the form from submitting immediately

            // Show SweetAlert confirmation
            Swal.fire({
                title: 'ยืนยันการส่งข้อมูล?',
                text: "คุณต้องการบันทึกข้อมูลนี้หรือไม่?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'ใช่, บันทึกเลย!'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Submit the form after user confirms
                    this.submit();
                }
            });
        });
    </script>
</body>

</html>

<?php
// ปิดการเชื่อมต่อฐานข้อมูล
$conn->close();
?>