<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $usrname   = $_POST['usrname'];
        $pwd1   = $_POST['pwd1'];
        $pwd2   = $_POST['pwd2'];
        $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['name']);
        $addr   = iconv("UTF-8","gbk//TRANSLIT",$_POST['address']);
        $year   = $_POST['year'];
        $month  = $_POST['month'];
        $day    = $_POST['day'];
        $phone  = $_POST['phonenum'];
        // �жϸ��û��Ƿ�ע��
        $sql="select * from loginInfo where USRNAME = '$usrname'";
        $result = sqlsrv_query($con,$sql);
        $row = sqlsrv_fetch_array($result);
        // ���δע��
        if (!$row){
            if ($pwd1 == $pwd2){
                $sql = "insert into loginInfo(USRNAME,PASSWORD) values('$usrname','$pwd1')";
                sqlsrv_query($con,$sql);
                $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone'";
                echo $sql;
                sqlsrv_query($con,$sql);
                echo 'ע��ɹ�ȥ<a href="login.html">��¼</a>';
            } 
            else{
                echo '��ȷ�������<a href="signup.html">����</a>!';
            }
        }
        // ����Ѿ�ע��
        else{
            echo '���û��Ѿ�ע��ȥ<a href="login.html">��¼</a>?';
        }

    }
    sqlsrv_close($con);
?>