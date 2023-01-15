<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist</title>
</head>
<body>
    <?php
        include 'connection.php';
        if ($_SERVER["REQUEST_METHOD"] == "POST"){
            $module = $_POST['Query'];
            $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
            $sql = "";
            switch ($module) {
                case '1':
                    $sql = "exec guest.showAllArtist";
                    break;
                case '2':
                    $sql = "exec guest.showGalleryArtist '$key'";
                    break;
                case '3':
                    $sql = "exec guest.showExbArtist '$key'";
                    break;
                case '4':
                    $sql = "exec guest.showStyleArtist '$key'";
                    break;
                case '5':
                    $sql = "exec guest.showTypicalArtist '$key','$key'";
                    break;
                default:
                    echo "Something error!";
                    break;
            }
            $result = sqlsrv_query($con,$sql);
            if ($result){
                echo "<table><tr><th>艺术家号</th><th>姓名</th><th>出生地</th><th>作品风格</th><th>签约画廊</th><tr>";
                while($row = sqlsrv_fetch_array($result)){
                    echo "<tr><td>" .$row["艺术家号"]. "</td><td>" .$row["姓名"]. "</td><td>" .$row["出生地"]. "</td>
                    <td>" .$row["作品风格"]. "</td><td>" .$row["签约画廊"]. "</td></tr>";
                }
                echo "</table>";
            }
            else {
                die( print_r( sqlsrv_errors(), true));
            }
        }
        sqlsrv_close($con);
    ?>
</body>
</html>