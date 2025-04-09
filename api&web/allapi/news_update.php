<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload and Display Images</title>
    <style>
        /* CSS สำหรับการจัดตำแหน่งและตกแต่ง */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f4f4f4;
        }

        .container {
            width: 90%;
            max-width: 600px;
            text-align: center;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            margin: 20px;
        }

        .back-button {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
        }

        .back-button:hover {
            background-color: #45a049;
        }

        img {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
            width: 100%;
            max-width: 200px;
            height: auto;
        }

        button {
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
        }

        button:hover {
            background-color: #0b7dda;
        }

        form {
            margin-bottom: 20px;
        }

        div {
            margin-bottom: 20px;
        }

        @media (max-width: 600px) {
            .back-button {
                font-size: 0.9em;
                padding: 8px 12px;
            }

            button {
                font-size: 0.9em;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>

    <a href="main_menu.html" class="back-button">กลับหน้าหลัก</a>

    <div class="container">
        <h2>ช่าวสารปัจจุบัน</h2>

        <!-- PHP Code Section -->
        <?php
        $servername = "localhost";
        $username = "root";
        $password = "";
        $dbname = "news_db";

        // สร้างการเชื่อมต่อกับฐานข้อมูล
        $conn = new mysqli($servername, $username, $password, $dbname);

        // ตรวจสอบการเชื่อมต่อ
        if ($conn->connect_error) {
            die("การเชื่อมต่อฐานข้อมูลล้มเหลว: " . $conn->connect_error);
        }

        // ตรวจสอบว่ามีการอัปโหลดไฟล์หรือไม่
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $imageId = $_POST['image_id']; // รับค่า image_id เพื่ออัปเดตรูปที่เลือก
            $inputName = 'news_image' . $imageId;

            if (isset($_FILES[$inputName]) && $_FILES[$inputName]['error'] === 0) {
                $targetDirectory = 'uploads/';
                $fileName = basename($_FILES[$inputName]['name']); // ชื่อไฟล์ที่ถูกอัปโหลด
                $targetFile = $targetDirectory . $fileName; // เส้นทางเต็มของไฟล์ที่จะอัปโหลด
                $imageFileType = strtolower(pathinfo($targetFile, PATHINFO_EXTENSION));
                $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];

                // ตรวจสอบชนิดไฟล์
                if (in_array($imageFileType, $allowedExtensions)) {
                    if (move_uploaded_file($_FILES[$inputName]['tmp_name'], $targetFile)) {
                        // อัปเดตเส้นทางและชื่อไฟล์ในฐานข้อมูล
                        $stmt = $conn->prepare("UPDATE images SET file_path = ?, file_name = ? WHERE id = ?");
                        $stmt->bind_param("ssi", $targetFile, $fileName, $imageId);

                        if ($stmt->execute()) {
                            echo "อัปโหลดรูปภาพ $imageId สำเร็จ: " . htmlspecialchars($fileName) . "<br>";
                        } else {
                            echo "เกิดข้อผิดพลาดในการบันทึกลงฐานข้อมูลรูปภาพ $imageId<br>";
                        }
                        $stmt->close();
                    } else {
                        echo "เกิดข้อผิดพลาดในการอัปโหลดไฟล์รูปภาพ $imageId<br>";
                    }
                } else {
                    echo "ไม่รองรับชนิดของไฟล์รูปภาพ $imageId<br>";
                }
            }
        }

        // ดึงข้อมูลรูปภาพจากฐานข้อมูล
        $sql = "SELECT id, file_name, file_path FROM images";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                echo "<div>";
                echo "<p>รูปที่ " . $row['id'] . ":</p>";
                echo "<img src='" . $row['file_path'] . "' width='200'><br>";

                echo "<form action='' method='post' enctype='multipart/form-data'>";
                echo "<input type='hidden' name='image_id' value='" . $row['id'] . "'>";
                echo "<input type='file' name='news_image" . $row['id'] . "' accept='image/*'>";
                echo "<button type='submit'>อัปโหลด</button>";
                echo "</form>";
                echo "<br><br>";
                echo "</div>";
            }
        } else {
            echo "ไม่มีรูปภาพในฐานข้อมูล";
        }

        $conn->close();
        ?>
    </div>
</body>
</html>
