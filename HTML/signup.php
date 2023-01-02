<?php
    header("Content-Type:text/html;CHARSET=GBK");
    $serverName = "(local)";
    $connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");
    $con = sqlsrv_connect( $serverName, $connectionInfo);
    if( !$con ){
        echo "Connection could not be established.\n";
        die( var_dump(sqlsrv_errors()));
    }
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $usrname   = $_POST['usrname'];
        $pwd1   = $_POST['pwd1'];
        $pwd2   = $_POST['pwd2'];
        // 将POST过来的UTF-8编码转换为GBK编码
        $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['name']);
        $addr   = iconv("UTF-8","gbk//TRANSLIT",$_POST['address']);
        $year   = $_POST['year'];
        $month  = $_POST['month'];
        $day    = $_POST['day'];
        $phone  = $_POST['phonenum'];
        // 判断是否注册
        $sql="select * from loginInfo where USRNAME = '$usrname'";
        $result = sqlsrv_query($con,$sql);
        // 取一行数据
        $row = sqlsrv_fetch_array($result);
        if (!$row){
            if ($pwd1 == $pwd2){
                $sql = "insert into loginInfo(USRNAME,PASSWORD) values('$usrname','$pwd1')";
                sqlsrv_query($con,$sql);
                $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone'";
                echo $sql;
                sqlsrv_query($con,$sql);
                echo '注册成功！前去<a href="login.html">登录</a>';
            } 
            else{
                echo '请确认密码后<a href="signup.html">重试</a>!';
            }
        }
        else{
            echo '该用户名已经注册。去<a href="login.html">登录</a>?';
        }

    }
    sqlsrv_close($con);
?>