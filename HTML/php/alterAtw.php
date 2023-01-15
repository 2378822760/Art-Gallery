<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        if (isset($_POST['mode'])){
            $mode = $_POST['mode'];
            $aid = $_POST['aid'];
            // 确认修改
            if($mode == '1'){
                $aname = iconv("UTF-8","gbk//TRANSLIT",$_POST['aname']);
                $atype = iconv("UTF-8","gbk//TRANSLIT",$_POST['atype']);
                $ayear = iconv("UTF-8","gbk//TRANSLIT",$_POST['ayear']);
                $aprice = $_POST['aprice'];
                $sql = "update ARTWORK set ARTTITLE = '$aname',ARTTYPE = '$atype',ARTYEAR = '$ayear',ARTPRICE =  $aprice where ARTID = '$aid'";
                $result = sqlsrv_query($con, $sql);
                if (!$result) {
                    die( print_r( sqlsrv_errors(), true));
                }
                die('success');
            }
            // 删除
            else if($mode == '2'){
                $sql = "delete from ARTWORK where ARTID = '$aid'";
                $result = sqlsrv_query($con, $sql);
                if (!$result) {
                    die( print_r( sqlsrv_errors(), true));
                }
                die('success');
            }
            // 异常
            else{
                die('fail');
            }
        }
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
            echo "<table><tr><th>作品号</th><th>作品名</th><th>作品类型</th><th>创作年份</th><th>参考价</th>
            <th>状态</th><th>作者号</th><th>所属画廊</th><th>所属展览</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr id = $i><td>" .$row['作品号']. "</td><td>" .$row['作品名']. "</td><td>" .$row['作品类型']. "</td><td>" .$row['创作年份']. "</td> 
                <td>￥" .$row['参考价']. "</td><td>" .$row['状态']. "</td><td>" .$row['作者号']. 
                "</td><td>" .$row['所属画廊']. "</td><td>" .$row['所属展览']. 
                "</td><td><a href='javaScript:void(0)' onclick='alter($i)'>修改</a></td>" . 
                "<td><a href='javaScript:void(0)' onclick='remove($i)'>qtm不要了</a></td></tr>";
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