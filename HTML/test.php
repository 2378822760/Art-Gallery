<?php
header("Content-Type:text/html;CHARSET=GBK");
$serverName = "(local)";

$connectionInfo = array("UID"=>"sa","PWD"=>"zck011125","Database"=>"AG");

$conn = sqlsrv_connect( $serverName, $connectionInfo);

$sql  = "exec Manager.loginCustomer '≤‹”Ó–«','Ω≠À’ŒﬁŒ˝','2001-1-1','15505284491'";
$stmt = sqlsrv_query( $conn, $sql );
if( $stmt === false ) {
    if( ($errors = sqlsrv_errors() ) != null) {
        foreach( $errors as $error ) {
            echo "SQLSTATE: ".$error[ 'SQLSTATE']."<br />";
            echo "code: ".$error[ 'code']."<br />";
            echo "message: ".$error[ 'message']."<br />";
        }
    }
}

echo "execute it!";
// $row = sqlsrv_fetch_array($result);
// echo $row;
sqlsrv_close( $conn);

?>