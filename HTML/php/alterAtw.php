<?php
    include 'connection.php';
    if ($_SERVER["REQUEST_METHOD"] == "POST"){
        if (isset($_POST['mode'])){
            $mode = $_POST['mode'];
            $aid = $_POST['aid'];
            // ȷ���޸�
            if($mode == '1'){
                $aname = iconv("UTF-8","gbk//TRANSLIT",$_POST['aname']);
                $atype = iconv("UTF-8","gbk//TRANSLIT",$_POST['atype']);
                $ayear = iconv("UTF-8","gbk//TRANSLIT",$_POST['ayear']);
                $aprice = $_POST['aprice'];
                $sql = "update ARTWORK set ARTTITLE = '$aname',ARTTYPE = '$atype',ARTYEAR = '$ayear',ARTPRICE =  $aprice where ARTID = '$aid'";
                $result = sqlsrv_query($con, $sql);
                if (!$result) {
                    die( print_r( sqlsrv_errors(), true));
                }
                die('success');
            }
            // ɾ��
            else if($mode == '2'){
                $sql = "delete from ARTWORK where ARTID = '$aid'";
                $result = sqlsrv_query($con, $sql);
                if (!$result) {
                    die( print_r( sqlsrv_errors(), true));
                }
                die('success');
            }
            // �쳣
            else{
                die('fail');
            }
        }
        $module = $_POST['Query'];
        $key = iconv("UTF-8","gbk//TRANSLIT",$_POST['content']);
        $sql = "";
        switch ($module) {
            case '1':
                $sql = "exec guest.showAllArtwk";
                break;
            case '2':
                $sql = "exec guest.showGalleryArtwk '$key'";
                break;
            case '3':
                $sql = "exec guest.showExbArtwk '$key'";
                break;
            case '4':
                $sql = "exec guest.showArtistArtwk '$key'";
                break;
            case '5':
                $sql = "exec guest.showTypicalArtwk '$key'";
                break;
            case '6':
                $sql = "exec guest.exactFindArtwk '$key'";
                break;
            default:
                echo "Something error!";
                break;
        }
        $result = sqlsrv_query($con,$sql);
        if ($result) {
            $i = 0;
            echo "<table><tr><th>��Ʒ��</th><th>��Ʒ��</th><th>��Ʒ����</th><th>�������</th><th>�ο���</th>
            <th>״̬</th><th>���ߺ�</th><th>��������</th><th>����չ��</th><tr>";
            while($row = sqlsrv_fetch_array($result)){
                echo "<tr id = $i><td>" .$row['��Ʒ��']. "</td><td>" .$row['��Ʒ��']. "</td><td>" .$row['��Ʒ����']. "</td><td>" .$row['�������']. "</td> 
                <td>��" .$row['�ο���']. "</td><td>" .$row['״̬']. "</td><td>" .$row['���ߺ�']. 
                "</td><td>" .$row['��������']. "</td><td>" .$row['����չ��']. 
                "</td><td><a href='javaScript:void(0)' onclick='alter($i)'>�޸�</a></td>" . 
                "<td><a href='javaScript:void(0)' onclick='remove($i)'>qtm��Ҫ��</a></td></tr>";
                $i++;
            }
            echo "</table>";
        }
        else{
            die( print_r( sqlsrv_errors(), true));
        }
    }
    sqlsrv_close( $con);
?>