<?php
    include "connectWithoutCheck.php";
    $key = '水墨';
    $sql = "select * from ARTWORK where GID like '%$key%' or EID like '%$key%' or ARTISTID like '%$key%' or ARTTYPE like '%$key%' or ARTTITLE like '%$key%' or ARTID like '%$key%'";
    $result = sqlsrv_query($con,$sql);
    if ($result) {
        echo "<table width=1000px><tr><th>作品号</th><th>作品名</th><th>作品类型</th><th>创作年份</th><th>参考价</th>
        <th>状态</th><th>作者号</th><th>所属画廊</th><th>所属展览</th><tr>";
        while($row = sqlsrv_fetch_array($result)){
            echo "<tr><td>" .$row['ARTID']. "</td><td>" .$row['ARTTITLE']. "</td><td>" .$row['ARTTYPE']. "</td><td>" .$row['ARTYEAR']. "</td> 
            <td>" .$row['ARTPRICE']. "</td><td>" .$row['ARTSTATUS']. "</td><td>" .$row['ARTISTID']. 
            "</td><td>" .$row['GID']. "</td><td>" .$row['EID']. "</td></tr>";
        }
        echo "</table>";
    }
    else{
        die( print_r( sqlsrv_errors(), true));
    }
?>
