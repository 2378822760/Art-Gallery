<?php
    $serverName = "(local)";
    $connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");
    $con = sqlsrv_connect( $serverName, $connectionInfo);
    if( !$con ){
        echo "Connection could not be established.\n";
        die( var_dump(sqlsrv_errors()));
    }
    //开启SESSION
    session_start();
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $name = $_POST['usrname'];
        $pwd = $_POST['password'];
        $role = $_POST['role'];
        $sql="select * from loginInfo where USRNAME = '$name' and ROLE = '$role'";
        $result = sqlsrv_query($con,$sql);
        // 取一行数据
        $row = sqlsrv_fetch_array($result);
        if ($row){
            if ($row['PASSWORD'] == $pwd) {
                echo "登录成功!";
                $_SESSION['name'] = $name;
			    $_SESSION['password'] = $pwd;
                $_SESSION['role'] = $role;
                $url  =  "main$role.html";
                echo " <script   language = 'javascript' type = 'text/javascript'> "; 
                echo " window.location.href = '$url' "; 
                echo " </script> ";
            }
            else {
                echo "密码错误!";
            }
        }
        else{
            echo "该用户暂未注册！请先去<a href='signup.html'>注册</a>";
        }
    }
    sqlsrv_close( $con);
?>
