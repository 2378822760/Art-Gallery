<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllArtwk";
                break;
            case '2':
                $sql = "exec guest.showGalleryArtwk '$key'";
                break;
            case '3':
                $sql = "exec guest.showExbArtwk '$key'";
                break;
            case '4':
                $sql = "exec guest.showArtistArtwk '$key'";
                break;
            case '5':
                $sql = "exec guest.showTypicalArtwk '$key'";
                break;
            case '6':
                $sql = "exec guest.exactFindArtwk '$key'";
                break;
            default:
                echo "Something error!";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result) {
            $i = 0;
            echo "<table width=1000px><tr><th>作品号</th><th>作品名</th><th>作品类型</th><th>创作年份</th><th>参考价</th>
            <th>状态</th><th>作者号</th><th>所属画廊</th><th>所属展览</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr id = $i><td>" .$row['作品号']. "</td><td>" .$row['作品名']. "</td><td>" .$row['作品类型']. "</td><td>" .$row['创作年份']. "</td> 
                <td>￥" .$row['参考价']. "</td><td>" .$row['状态']. "</td><td>" .$row['作者号']. 
                "</td><td>" .$row['所属画廊']. "</td><td>" .$row['所属展览']. 
                "</td><td><a href='javaScript:void(0)' onclick='gotoBuy($i)'>购买</a></td></tr>";
                $i++;
            }
            echo "</table>";
        }
        else{
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close( $con);
?>