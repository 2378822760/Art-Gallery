<?php
    include 'connectWithoutCheck.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $usrname = $_POST['usrname'];
        $role = $_POST['role'];
        $email = $_POST['email'];
    }
    else{
        die("Something error!");
    }
    $sql = "select * from loginInfo where USRNAME = '$usrname' and ROLE = '$role' and EMAIL = '$email'";
    $result = sqlsrv_query($con,$sql);
    if (!$result){
        die( print_r( sqlsrv_errors(), true));
    }
    $row = sqlsrv_fetch_array($result);
    if (!$row){
        echo "���û���δע�����������Ϣ�����뷵������";
    }
    else{
        $sql = "updata loginInfo set PASSWORD = 'asd123!' where USRNAME = '$usrname'";
        $result = sqlsrv_query($con,$sql);
        if($result){
            echo "��������Ϊ<b>asd123</b>";
        }
        else{
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close( $con);
?>