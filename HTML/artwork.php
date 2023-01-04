<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllArtwk";
                break;
            case '2':
                $sql = "exec guest.showGalleryArtwk " .$_POST['gid'];
                break;
            case '3':
                $sql = "exec guest.showExbArtwk " .$_POST['eid'];
                break;
            case '4':
                $sql = "exec guest.showArtistArtwk " .$_POST['artistid'];
                break;
            case '5':
                $sql = "exec guest.showTypicalArtwk " .$_POST['type'];
                break;
            case '6':
                $sql = "exec guest.exactFindArtwk " .$_POST['id'];
                break;
            default:
                echo "Something error!";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result) {
            echo "<table width=1000px><tr><th>作品号</th><th>作品名</th><th>作品类型</th><th>创作年份</th><th>参考价</th>
            <th>状态</th><th>作者号</th><th>所属画廊</th><th>所属展览</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr><td>" .$row['作品号']. "</td><td>" .$row['作品名']. "</td><td>" .$row['作品类型']. "</td><td>" .$row['创作年份']. "</td> 
                <td>" .$row['参考价']. "</td><td>" .$row['状态']. "</td><td>" .$row['作者号']. 
                "</td><td>" .$row['所属画廊']. "</td><td>" .$row['所属展览']. "</td></tr>";
            }
            echo "</table>";
        }
    }
?>