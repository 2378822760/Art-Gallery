<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $name = $_POST['usrname'];
        $pwd = $_POST['password'];
        $sql="select * from loginInfo where USRNAME = '$name'";
        $result = sqlsrv_query($con,$sql);
        // 取一行数据
        $row = sqlsrv_fetch_array($result);
        if ($row){
            if (strcmp($row['PASSWORD'],$pwd)) {
                echo "登录成功!";
                $url  =  "index.html" ; 
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
