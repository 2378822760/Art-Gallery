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
        $role   = $_POST['role'];
        if ($role == "customer"){
            $usrname   = $_POST['cusrname'];
            $pwd1   = $_POST['cpwd1'];
            $pwd2   = $_POST['cpwd2'];
            $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['cname']);
        }
        else if ($role == "artist"){
            $usrname   = $_POST['ausrname'];
            $pwd1   = $_POST['apwd1'];
            $pwd2   = $_POST['apwd2'];
            $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['aname']);
        }
        else if ($role == "gallery"){
            $usrname   = $_POST['gusrname'];
            $pwd1   = $_POST['gpwd1'];
            $pwd2   = $_POST['gpwd2'];
            $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['gname']);
        } 
        else{
            die('Something error!');
        }
        $addr   = iconv("UTF-8","gbk//TRANSLIT",$_POST['address']);
        $year   = $_POST['year'];
        $month  = $_POST['month'];
        $day    = $_POST['day'];
        $phone  = $_POST['phonenum'];
        $bp = iconv("UTF-8","gbk//TRANSLIT",$_POST['bp']);
        $style = iconv("UTF-8","gbk//TRANSLIT",$_POST['style']);
        $loc = iconv("UTF-8","gbk//TRANSLIT",$_POST['location']);
        // �жϸ��û��Ƿ�ע��
        $sql="select * from loginInfo where USRNAME = '$usrname' and ROLE = '$role'";
        $result = sqlsrv_query($con,$sql);
        $row = sqlsrv_fetch_array($result);
        // ���δע��
        if (!$row){
            if ($pwd1 == $pwd2){
                $sql = "insert into loginInfo(USRNAME,PASSWORD,ROLE) values('$usrname','$pwd1','$role')";
                sqlsrv_query($con,$sql);
                if ($role == "customer"){
                    $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone'";
                }
                else if ($role == "artist"){
                    $sql = "exec Manager.loginArtist '$name','$bp','$style'";
                }
                else if ($role == "gallery"){
                    $sql = "exec Manager.loginGallery '$name','$loc'";
                } 
                else{
                    die('Something error!');
                }
                sqlsrv_query($con,$sql);
                echo 'ע��ɹ�ȥ<a href="index.html">��¼</a>';
            } 
            else{
                echo '��ȷ�������<a href="signup.html">����</a>!';
            }
        }
        // ����Ѿ�ע��
        else{
            echo '���û��Ѿ�ע��ȥ<a href="index.html">��¼</a>?';
        }

    }
    sqlsrv_close($con);
?>