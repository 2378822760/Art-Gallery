<?php
    include "connectWithoutCheck.php";
    $key = 'ˮī';
    $sql = "select * from ARTWORK where GID like '%$key%' or EID like '%$key%' or ARTISTID like '%$key%' or ARTTYPE like '%$key%' or ARTTITLE like '%$key%' or ARTID like '%$key%'";
    $result = sqlsrv_query($con,$sql);
    if ($result) {
        echo "<table width=1000px><tr><th>��Ʒ��</th><th>��Ʒ��</th><th>��Ʒ����</th><th>�������</th><th>�ο���</th>
        <th>״̬</th><th>���ߺ�</th><th>��������</th><th>����չ��</th><tr>";
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
