<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php
        header("Content-Type:text/html;CHARSET=GBK");
        $serverName = "(local)";
        $connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");
        $con = sqlsrv_connect( $serverName, $connectionInfo);
        if( !$con ){
            echo "Connection could not be established.\n";
            die( var_dump(sqlsrv_errors()));
        }
        if ($_SERVER["REQUEST_METHOD"] == "POST"){
            $module = $_POST['Query'];
            if ($module == '1'){
                $sql="SELECT * FROM GALLERY";
                $result = sqlsrv_query($con,$sql);
                if ($result) {
                    echo "<table><tr><th>���Ⱥ�</th><th>������</th><th>����λ��</th><tr>";
                    while($row = sqlsrv_fetch_array($result)){
                        echo "<tr><td>" . $row["GID"]. "</td><td>" . $row["GNAME"]. "</td><td>" .$row["GLOCATION"]. "</td></tr>";
                    }
                    echo "</table>";
                }
            }
            else if ($module == '2'){
                $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
                $sql = "SELECT * FROM GALLERY WHERE GID = '$name' or GNAME = '$name'";
                $result = sqlsrv_query($con,$sql);
                if ($result) {
                    echo "<table><tr><th>���Ⱥ�</th><th>������</th><th>����λ��</th><tr>";
                    while($row = sqlsrv_fetch_array($result)){
                        echo "<tr><td>" . $row["GID"]. "</td><td>" . $row["GNAME"]. "</td><td>" .$row["GLOCATION"]. "</td></tr>";
                    }
                    echo "</table>";
                }
            }
            
        }
        sqlsrv_close( $con);
    ?>

</body>
</html>