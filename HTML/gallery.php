<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gallery</title>
</head>
<body>
    <?php
        include 'connection.php';
        if ($_SERVER["REQUEST_METHOD"] == "POST"){
            $module = $_POST['Query'];
            $sql = "";
            switch ($module) {
                case '1':
                    $sql = "SELECT * FROM GALLERY";
                    break;
                case '2':
                    $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
                    $sql = "SELECT * FROM GALLERY WHERE GID = '$name' or GNAME = '$name'";
                default:
                    echo "Something error";
                    break;
            }
            $result = sqlsrv_query($con,$sql);
            if ($result) {
                echo "<table><tr><th>画廊号</th><th>画廊名</th><th>画廊位置</th><tr>";
                while($row = sqlsrv_fetch_array($result)){
                    echo "<tr><td>" . $row["GID"]. "</td><td>" . $row["GNAME"]. "</td><td>" .$row["GLOCATION"]. "</td></tr>";
                }
                echo "</table>";
            }
        }
        sqlsrv_close( $con);
    ?>

</body>
</html>
