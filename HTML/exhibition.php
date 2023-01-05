<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllExb";
                break;
            case '2':
                $sql = "exec guest.showGalleryExb " .$_POST['gid'];
                break;
            default:
                echo "Something error";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result){
            echo "<table><tr><th>展览号</th><th>展览名</th><th>开始日期</th><th>结束日期</th><th>举办方</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr><td>" .$row["展览号"]. "</td><td>" .$row["展览名"]. "</td><td>" .date_format($row["开始日期"],'Y-m-d'). "</td>
                <td>" .date_format($row["结束日期"],'Y-m-d'). "</td><td>" .$row["举办方"]. "</td></tr>";
            }
            echo "</table>";
        }
        else {
            echo "Nothing finded!";
        }
    }
    sqlsrv_close($con);
?>