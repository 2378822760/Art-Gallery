<?php
    include 'connectWithoutCheck.php';
    //����SESSION
    session_start();
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $name = $_POST['usrname'];
        $pwd = $_POST['password'];
        $role = $_POST['role'];
        $sql="select * from loginInfo where USRNAME = '$name' and ROLE = '$role'";
        $result = sqlsrv_query($con,$sql);
        if (!$result) {
            die( print_r( sqlsrv_errors(), true));
        }
        // ȡһ������
        $row = sqlsrv_fetch_array($result);
        if ($row){
            if (rtrim($row['PASSWORD']) == $pwd) {
                echo "��¼�ɹ�!";
                $_SESSION['name'] = $name;
			    $_SESSION['password'] = $pwd;
                $_SESSION['role'] = $role;
                $url  =  "../main$role.html";
                echo " <script   language = 'javascript' type = 'text/javascript'> "; 
                echo " window.location.href = '$url' "; 
                echo " </script> ";
            }
            else {
                echo "�������!";
            }
        }
        else{
            echo "���û���δע�ᣡ����ȥ<a href='../signup.html'>ע��</a>";
        }
    }
    sqlsrv_close( $con);
?>
