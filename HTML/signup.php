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
        // ��POST������UTF-8����ת��ΪGBK����
        $name = iconv("UTF-8","gbk//TRANSLIT",$_POST['name']);
        $addr   = iconv("UTF-8","gbk//TRANSLIT",$_POST['address']);
        $year   = $_POST['year'];
        $month  = $_POST['month'];
        $day    = $_POST['day'];
        $phone  = $_POST['phonenum'];
        // �ж��Ƿ�ע��
        $sql="select * from loginInfo where USRNAME = '$usrname'";
        $result = sqlsrv_query($con,$sql);
        // ȡһ������
        $row = sqlsrv_fetch_array($result);
        if (!$row){
            if ($pwd1 == $pwd2){
                $sql = "insert into loginInfo(USRNAME,PASSWORD) values('$usrname','$pwd1')";
                sqlsrv_query($con,$sql);
                $sql = "exec Manager.loginCustomer '$name','$addr','$year-$month-$day','$phone'";
                echo $sql;
                sqlsrv_query($con,$sql);
                echo 'ע��ɹ���ǰȥ<a href="login.html">��¼</a>';
            } 
            else{
                echo '��ȷ�������<a href="signup.html">����</a>!';
            }
        }
        else{
            echo '���û����Ѿ�ע�ᡣȥ<a href="login.html">��¼</a>?';
        }

    }
    sqlsrv_close($con);
?>