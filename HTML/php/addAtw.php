<?php
    include 'connection.php';
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
    $gid = $row['GID'];
    // 获取POST来的参数
    $name = $_POST['n'];
	$type = $_POST['t'];
	$cyear = $_POST['y'];
	$price = $_POST['p'];
	$artistid = $_POST['aid'];
    // 作品入库
    $sql = "exec Gallery.addArtwk $name,$type,$cyear,$price,$artistid,$gid";
    $result = sqlsrv_query($con,$sql);
    if (!$result){
        die( print_r( sqlsrv_errors(), true));
    }
    sqlsrv_close($con);
    echo "success";
    
?>