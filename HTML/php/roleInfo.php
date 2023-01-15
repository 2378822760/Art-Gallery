<?php
    include "connection.php";
    $usrname = $_SESSION['name'];
    $role = $_SESSION['role'];
    $tbName = strtoupper($role);
    $sql = "select * from $tbName where ARTISTID in (select ID from loginInfo where USRNAME = '$usrname' and ROLE = '$role')";
    $result  = sqlsrv_query($con,$sql);
    if (!$result){
        die( print_r( sqlsrv_errors(), true));
    }
    $row = sqlsrv_fetch_array($result);
    echo "<table><tr><th>艺术家号</th><th>姓名</th><th>出生地</th><th>作品风格</th><th>签约画廊</th><tr>";
    echo "<tr><td>" .$row["ARTISTID"]. "</td><td>" .$row["ARTISTNAME"]. "</td><td>" .$row["ARTISTBP"]. "</td>
    <td>" .$row["ARTISTSTYLE"]. "</td><td>" .$row["GID"]. "</td></tr>";
    echo "</table>";
    sqlsrv_close( $con);
?>