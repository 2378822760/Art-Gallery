<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllExb";
                break;
            case '2':
                $sql = "exec guest.showGalleryExb '$key'";
                break;
            case '3':
                $sql = "select EXHIBITION.EID as 展览号, ENAME as 展览名, ESTARTDATE as 开始日期, EENDDATE as 结束日期, GNAME as 举办方 
                from EXHIBITION left outer join GALLERY on EXHIBITION.GID = GALLERY.GID WHERE ENAME like '%$key%' or EID = '$key'";
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
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close($con);
?>