<?php
    include 'connectWithoutCheck.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $role   = $_POST['role'];
        $usrname   = $_POST['usrname'];
        $pwd1   = $_POST['pwd1'];
        $pwd2   = $_POST['pwd2'];
        $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['name']);
        $email = $_POST['email'];
        $addr   = iconv("UTF-8","gbk//TRANSLIT",$_POST['address']);
        $year   = $_POST['year'];
        $month  = $_POST['month'];
        $day    = $_POST['day'];
        $phone  = $_POST['phonenum'];
        $bp = iconv("UTF-8","gbk//TRANSLIT",$_POST['bp']);
        $style = iconv("UTF-8","gbk//TRANSLIT",$_POST['style']);
        $gname = iconv("UTF-8","gbk//TRANSLIT",$_POST['gname']);
        $loc = iconv("UTF-8","gbk//TRANSLIT",$_POST['location']);
        // 判断该用户是否注册
        $sql="select * from loginInfo where USRNAME = '$usrname' and ROLE = '$role'";
        $result = sqlsrv_query($con,$sql);
        if (!$result){
            die( print_r( sqlsrv_errors(), true));
        }
        $row = sqlsrv_fetch_array($result);
        // 如果未注册
        if (!$row){
            if ($pwd1 == $pwd2){
                if ($role == "customer"){
                    $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone','$usrname','$pwd1','$email'";
                }
                else if ($role == "artist"){
                    $sql = "exec Manager.loginArtist '$name','$bp','$style','$usrname','$pwd1','$email'";
                }
                else if ($role == "gallery"){
                    $sql = "exec Manager.loginGallery '$gname','$loc','$usrname','$pwd1','$email'";
                } 
                else{
                    die('Something error!');
                }
                $result = sqlsrv_query($con,$sql);
                if ($result){
                    echo '注册成功去<a href="../index.html">登录</a>';
                }
                else{
                    die("Something error!");
                }
            } 
            else{
                echo '请确认密码后<a href="../signup.html">重试</a>!';
            }
        }
        // 如果已经注册
        else{
            echo '该用户已经注册去<a href="../index.html">登录</a>?';
        }

    }
    sqlsrv_close($con);
?>