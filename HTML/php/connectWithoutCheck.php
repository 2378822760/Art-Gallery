<?php
    header("Content-Type:text/html;CHARSET=GBK");
    $serverName = "(local)";
    $connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");
    $con = sqlsrv_connect( $serverName, $connectionInfo);
    if( !$con ){
        echo "Connection could not be established.\n";
        die( var_dump(sqlsrv_errors()));
    }
?>