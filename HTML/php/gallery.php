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
            $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
            $sql = "";
            switch ($module) {
                case '1':
                    $sql = "SELECT * FROM GALLERY";
                    break;
                // ͨ������λ�ò�ѯ
                case '2':
                    $sql = "SELECT * FROM GALLERY WHERE GLOCATION like '%$key%'";
                    break;
                // ͨ��ID�����ֲ�ѯ
                case '3':
                    $sql = "SELECT * FROM GALLERY WHERE GNAME like '%$key%' or GID = '$key'";
                    break;
                default:
                    echo "Something error";
                    break;
            }
            $result = sqlsrv_query($con,$sql);
            if ($result) {
                echo "<table><tr><th>���Ⱥ�</th><th>������</th><th>����λ��</th><tr>";
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