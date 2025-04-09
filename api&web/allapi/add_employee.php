<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>เพิ่มพนักงาน</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 600px;
            padding: 40px;
            margin-top: 20px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            font-weight: bold;
            color: #555;
            text-align: left;
        }

        input,
        select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
        }

        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 1rem;
            padding: 12px;
            border-radius: 5px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
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
            font-size: 1rem;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        .message {
            margin-top: 20px;
            color: green;
            font-weight: bold;
        }

        .error {
            color: red;
        }

        .dropdown-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .dropdown-container label {
            margin: 0;
            flex-basis: 40%;
            text-align: left;
        }

        .dropdown-container select {
            flex-basis: 60%;
        }

        @media (max-width: 600px) {
            .container {
                width: 100%;
                margin: 20px;
            }

            h2 {
                font-size: 1.2rem;
            }

            input,
            select,
            input[type="submit"] {
                font-size: 0.9rem;
                padding: 10px;
            }

            .back-button {
                font-size: 0.9rem;
            }
        }
    </style>
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>

<body>

    <!-- ปุ่มกลับหน้าหลัก -->
    <button class="back-button" onclick="location.href='main_menu.html'">กลับหน้าหลัก</button>

    <div class="container">
        <h2>เพิ่มพนักงานใหม่</h2>
        <form action="process_add_employee.php" method="POST">
            <label for="profile_name">ชื่อ - สกุล ผู้ใช้:</label>
            <input type="text" id="profile_name" name="profile_name" required>

            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="bill_code">รหัสวางบิล:</label>
            <input type="text" id="bill_code" name="bill_code" required>

            <label for="phone">เบอร์โทร:</label>
            <input type="tel" id="phone" name="phone" required>

            <label for="car_type">ประเภทรถ:</label>
            <input type="text" id="car_type" name="car_type" required>

            <label for="car_regis">ทะเบียนรถ:</label>
            <input type="text" id="car_regis" name="car_regis" required>

            <label for="regis_province">จังหวัดที่จดทะเบียน:</label>
            <input type="text" id="regis_province" name="regis_province" required>

            <label for="car_brand">ยี่ห้อรถ:</label>
            <input type="text" id="car_brand" name="car_brand" required>

            <label for="tank_number">หมายเลขถัง:</label>
            <input type="text" id="tank_number" name="tank_number" required>

            <label for="department_leader">หัวหน้าแผนก:</label>
            <input type="text" id="department_leader" name="department_leader" required>

            <label for="department_phone">เบอร์หัวหน้าแผนก:</label>
            <input type="tel" id="department_phone" name="department_phone" required>

            <label for="branch">สาขา:</label>
            <input type="text" id="branch" name="branch" required>

            <div class="dropdown-container">
                <label for="web_permission">สิทธิ์การใช้งานเว็บ:</label>
                <select id="web_permission" name="web_permission">
                    <option value="1">ใช้งานได้</option>
                    <option value="2">ใช้งานไม่ได้</option>
                </select>
            </div>

            <input type="submit" value="เพิ่มพนักงาน">
        </form>

        <!-- แสดงข้อความยืนยันหรือข้อผิดพลาด -->
        <div class="message">
            <?php
            if (isset($_GET['status'])) {
                $status = $_GET['status'];
                echo "<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.js'></script>";
                if ($status === 'success') {
                    echo "<script>
                        Swal.fire({
                            title: 'สำเร็จ!',
                            text: 'เพิ่มพนักงานสำเร็จ',
                            icon: 'success',
                            confirmButtonText: 'ตกลง'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.location.href = 'user_info.php';
                            }
                        });
                    </script>";
                } elseif ($status === 'error') {
                    echo "<script>
                        Swal.fire({
                            title: 'ผิดพลาด!',
                            text: 'เกิดข้อผิดพลาดในการเพิ่มพนักงาน',
                            icon: 'error',
                            confirmButtonText: 'ตกลง'
                        });
                    </script>";
                } elseif ($status === 'error_billcode') {
                    echo "<script>
                        Swal.fire({
                            title: 'ผิดพลาด!',
                            text: 'รหัสวางบิลซ้ำในฐานข้อมูล!',
                            icon: 'error',
                            confirmButtonText: 'ตกลง'
                        });
                    </script>";
                } elseif ($status === 'error_username') {
                    echo "<script>
                        Swal.fire({
                            title: 'ผิดพลาด!',
                            text: 'Username ซ้ำ!',
                            icon: 'error',
                            confirmButtonText: 'ตกลง'
                        });
                    </script>";
                }
            }
            ?>
        </div>
    </div>

</body>

</html>
