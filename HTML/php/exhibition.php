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
                $sql = "select EXHIBITION.EID as չ����, ENAME as չ����, ESTARTDATE as ��ʼ����, EENDDATE as ��������, GNAME as �ٰ췽 
                from EXHIBITION left outer join GALLERY on EXHIBITION.GID = GALLERY.GID WHERE ENAME like '%$key%' or EID = '$key'";
                break;
            default:
                echo "Something error";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result){
            echo "<table><tr><th>չ����</th><th>չ����</th><th>��ʼ����</th><th>��������</th><th>�ٰ췽</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr><td>" .$row["չ����"]. "</td><td>" .$row["չ����"]. "</td><td>" .date_format($row["��ʼ����"],'Y-m-d'). "</td>
                <td>" .date_format($row["��������"],'Y-m-d'). "</td><td>" .$row["�ٰ췽"]. "</td></tr>";
            }
            echo "</table>";
        }
        else {
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close($con);
?>