<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        $module = $_POST['Query'];
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllArtwk";
                break;
            case '2':
                $sql = "exec guest.showGalleryArtwk " .$_POST['gid'];
                break;
            case '3':
                $sql = "exec guest.showExbArtwk " .$_POST['eid'];
                break;
            case '4':
                $sql = "exec guest.showArtistArtwk " .$_POST['artistid'];
                break;
            case '5':
                $sql = "exec guest.showTypicalArtwk " .$_POST['type'];
                break;
            case '6':
                $sql = "exec guest.exactFindArtwk " .$_POST['id'];
                break;
            default:
                echo "Something error!";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result) {
            echo "<table width=1000px><tr><th>��Ʒ��</th><th>��Ʒ��</th><th>��Ʒ����</th><th>�������</th><th>�ο���</th>
            <th>״̬</th><th>���ߺ�</th><th>��������</th><th>����չ��</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr><td>" .$row['��Ʒ��']. "</td><td>" .$row['��Ʒ��']. "</td><td>" .$row['��Ʒ����']. "</td><td>" .$row['�������']. "</td> 
                <td>" .$row['�ο���']. "</td><td>" .$row['״̬']. "</td><td>" .$row['���ߺ�']. 
                "</td><td>" .$row['��������']. "</td><td>" .$row['����չ��']. "</td></tr>";
            }
            echo "</table>";
        }
    }
?>