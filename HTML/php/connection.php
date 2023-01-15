<?php
    header("Content-Type:text/html;CHARSET=GBK");
    //开启SESSION
    session_start();
    //判断用户是否登入
    if (empty($_SESSION['name'])) {
        header("refresh:0.1,url=login.html");
        die();
    }
    $serverName = "(local)";
    $connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");
    $con = sqlsrv_connect( $serverName, $connectionInfo);
    if( !$con ){
        echo "Connection could not be established.\n";
        die( var_dump(sqlsrv_errors()));
    }
?>