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
    echo "<table><tr><th>�����Һ�</th><th>����</th><th>������</th><th>��Ʒ���</th><th>ǩԼ����</th><tr>";
    echo "<tr><td>" .$row["ARTISTID"]. "</td><td>" .$row["ARTISTNAME"]. "</td><td>" .$row["ARTISTBP"]. "</td>
    <td>" .$row["ARTISTSTYLE"]. "</td><td>" .$row["GID"]. "</td></tr>";
    echo "</table>";
    sqlsrv_close( $con);
?>