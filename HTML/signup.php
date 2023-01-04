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
        // 判断该用户是否注册
        $sql="select * from loginInfo where USRNAME = '$usrname'";
        $result = sqlsrv_query($con,$sql);
        $row = sqlsrv_fetch_array($result);
        // 如果未注册
        if (!$row){
            if ($pwd1 == $pwd2){
                $sql = "insert into loginInfo(USRNAME,PASSWORD) values('$usrname','$pwd1')";
                sqlsrv_query($con,$sql);
                $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone'";
                echo $sql;
                sqlsrv_query($con,$sql);
                echo '注册成功去<a href="login.html">登录</a>';
            } 
            else{
                echo '请确认密码后<a href="signup.html">重试</a>!';
            }
        }
        // 如果已经注册
        else{
            echo '该用户已经注册去<a href="login.html">登录</a>?';
        }

    }
    sqlsrv_close($con);
?>