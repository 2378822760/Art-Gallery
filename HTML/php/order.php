<?php
    // �����߼������������������ҳ�洴������
    // ���������ʾ����
    // ���ȷ�Ͻ��׳ɹ�
    // �ر�ҳ����ߵ��ȡ����������
    include 'connection.php';
    if ($_POST['cancel'] == '1'){
        $tid = $_POST['tid'];
        $sql = "exec Gallery.alterOrderStatus '$tid','ȡ��'";
        $result = sqlsrv_query($con, $sql);
        if (!$result) {
            die( print_r( sqlsrv_errors(), true));
        }
        echo "success";
        die();
    }
    // ͨ��session�е�usrname��ȡ��ǰ�˿͵�CID
    $usrname = $_SESSION['name'];
    // ��ȡǰ�˴�����aid��gid
    $aid = $_POST['aid'];
    $gid = $_POST['gid'];
    $sql = "select ID as CID from loginInfo where USRNAME = '$usrname' and ROLE = 'customer'";
    $result = sqlsrv_query($con, $sql);
    if (!$result) {
        die( print_r( sqlsrv_errors(), true));
    }
    $row = sqlsrv_fetch_array($result);
    if (!$row){
        die("Something error!");
    }
    $cid = $row['CID'];
    // ��������
    $sql = "declare @tid char(16);
    exec Customer.createOrder '$cid','$aid','$gid',@tid OUTPUT;
    select @tid as tid;";
    $result = sqlsrv_query($con, $sql);
    if(!$result){
        echo "��������ʧ�ܣ����ν���ʧЧ,�����´���������";
        die();
    }
    // �����߿������ˣ����˺ü���Сʱ����ĲŽ��
    // �����INSERT, UPDATE or DELETE�᷵��һ�������...
    $nextResult = sqlsrv_next_result($result);
    $nextResult = sqlsrv_next_result($result);
    // $nextResult = sqlsrv_next_result($result);
    if( $nextResult ) {
        $row = sqlsrv_fetch_array($result);
        if (!$row) {
            die("get tid error!");
        }
        $tid = $row['tid'];
     } elseif( is_null($nextResult)) {
          echo "No more results.<br />";
     } else {
          die(print_r(sqlsrv_errors(), true));
     }
    $sql = "select * from TRADE where TRADEID = '$tid'";
    $result = sqlsrv_query($con, $sql);
    if (!$result) {
        die( print_r( sqlsrv_errors(), true));
    }
    $order = sqlsrv_fetch_array($result);
    if (!$order){
        die("Something error!");
    }
    echo "<ul>";
    echo "<li>�����ţ�<div id = 'key'>" . $order['TRADEID'] . "</div></li>";
    echo "<li>����" . $order['PRICE'] . "</li>";
    echo "<li>�˿ͱ�ţ�" . $order['CID'] . "</li>";
    echo "<li>�˿�������" . $order['CNAME'] . "</li>";
    echo "<li>����Ʒ��ţ�" . $order['ARTID'] . "</li>";
    echo "<li>����Ʒ����" . $order['ARTNAME'] . "</li>";
    echo "<li>�������ڣ�" . date_format($order['TRADEDATE'],'Y-m-d H:i:s') . "</li>";
    echo "<li>����״̬��" . $order['TRADESTATUS'] . "</li>";
    echo "<li>���ȱ�ţ�" . $order['GID'] . "</li>";
    echo "</ul>"
?>