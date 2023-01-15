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
                echo "<table><tr><th>�����Һ�</th><th>����</th><th>������</th><th>��Ʒ���</th><th>ǩԼ����</th><tr>";
                while($row = sqlsrv_fetch_array($result)){
                    echo "<tr><td>" .$row["�����Һ�"]. "</td><td>" .$row["����"]. "</td><td>" .$row["������"]. "</td>
                    <td>" .$row["��Ʒ���"]. "</td><td>" .$row["ǩԼ����"]. "</td></tr>";
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