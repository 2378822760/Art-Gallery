<?php
    // 订单逻辑：点击购买来到订单页面创建订单
    // 创建完后显示订单
    // 点击确认交易成功
    // 关闭页面或者点击取消结束订单
    include 'connection.php';
    if ($_POST['cancel'] == '1'){
        $tid = $_POST['tid'];
        $sql = "exec Gallery.alterOrderStatus '$tid','取消'";
        $result = sqlsrv_query($con, $sql);
        if (!$result) {
            die( print_r( sqlsrv_errors(), true));
        }
        echo "success";
        die();
    }
    // 通过session中的usrname获取当前顾客的CID
    $usrname = $_SESSION['name'];
    // 获取前端传来的aid和gid
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
    // 创建订单
    $sql = "declare @tid char(16);
    exec Customer.createOrder '$cid','$aid','$gid',@tid OUTPUT;
    select @tid as tid;";
    $result = sqlsrv_query($con, $sql);
    if(!$result){
        echo "创建订单失败！本次交易失效,请重新创建订单！";
        die();
    }
    // 妈的这边坑死我了，搞了好几个小时他妈的才解决
    // 如果有INSERT, UPDATE or DELETE会返回一个结果集...
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
    echo "<li>订单号：<div id = 'key'>" . $order['TRADEID'] . "</div></li>";
    echo "<li>金额：￥" . $order['PRICE'] . "</li>";
    echo "<li>顾客编号：" . $order['CID'] . "</li>";
    echo "<li>顾客姓名：" . $order['CNAME'] . "</li>";
    echo "<li>艺术品序号：" . $order['ARTID'] . "</li>";
    echo "<li>艺术品名：" . $order['ARTNAME'] . "</li>";
    echo "<li>创建日期：" . date_format($order['TRADEDATE'],'Y-m-d H:i:s') . "</li>";
    echo "<li>订单状态：" . $order['TRADESTATUS'] . "</li>";
    echo "<li>画廊编号：" . $order['GID'] . "</li>";
    echo "</ul>"
?>