<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        // 通过session获得当前画廊GID
        $usrname = $_SESSION['name'];
        $sql = "select ID as GID from loginInfo where USRNAME = '$usrname' and ROLE = 'gallery'";
        $result = sqlsrv_query($con, $sql);
        if (!$result) {
            die( print_r( sqlsrv_errors(), true));
        }
        $row = sqlsrv_fetch_array($result);
        if (!$row){
            die("Something error!");
        }
        // $gid = $row['GID'];
        $gid = 'HS001';
        $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "select * from ARTIST where GID = '$gid'";
                break;
            case '4':
                $sql = "select * from ARTIST where GID = '$gid' and ARTISTSTYLE like '%$key%'";
                break;
            case '5':
                $sql = "select * from ARTIST where GID = '$gid' and (ARTISTID = '$key' or ARTISTNAME like '%$key%');";
                break;
            default:
                echo "Something error!";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result){
            $i = 0;
            echo "<table><tr><th>艺术家号</th><th>姓名</th><th>出生地</th><th>作品风格</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr id = $i><td>" .$row["ARTISTID"]. "</td><td>" .$row["ARTISTNAME"]. "</td><td>" .$row["ARTISTBP"]. "</td>
                    <td>" .$row["ARTISTSTYLE"]. 
                    "</td><td><a href='javaScript:void(0)' onclick='break($i)'>解约</a></td></tr>";
                $i++;
            }
            echo "</table>";
        }
        else {
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close($con);
?>