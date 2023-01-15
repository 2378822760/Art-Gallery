<?php
    include 'connection.php';
    function DataPageShow($PageNum){

        $skip=($PageNum-1)*10;#需要跳过的数据条数
        $link=mysqli_connect('localhost','root','','mysqltest');#连接数据库
        mysqli_set_charset($link,'utf8');#设置字符格式
        $sql="select * from sinanews limit {$skip},10";#编写MySQL执行语句
        $ExeResult=mysqli_query($link,$sql);#执行MySQL命令
        $DataResult=mysqli_fetch_all($ExeResult,MYSQLI_ASSOC);#获取执行结果
        mysqli_close($link);#关闭数据库
        return $DataResult;#返回查询到的数组格式数据
        
    }

    function DataShow($ShowData){

        foreach($ShowData as $index => $val){
			//此处的if判断是为了让单数行与双数行的底色不一样方便观测，具体颜色可自定义
            if($index%2){
                $color='lightblue';
            }else{
                $color='yellow';
            }
            $IndexId=($index%10)+1;//设置页面表格显示的序列号
            $tim=date('Y-n-d H:i:s',$val['inputtime']);//将存储的时间戳，改为具体格式输出
            echo "
            <tr style='background:{$color}'>
                <th class='ids'>{$IndexId}</th>
                <th class='cur'>{$val['title']}</th>
                <th class='cur'>{$val['keywords']}</th>
                <th class='cur'>{$val['author']}</th>
                <th style='width:310px;height:80px;text-align:center;'>{$val['content']}</th>
                <th class='imag'><img src='{$val['image']}' style='zoom: 15%;'></img></th>
                <th class='cur'>{$tim}</th>
                <th class='cur'><a>修改</a>&nbsp;<a>删除</a></th>
            </tr>";
            //echo输出HTML标签，class=''是具体的样式
        }
    }
    $AllRows=DataRowNumber();#获取数据的所有行数
    $AllPages=ceil($AllRows/10);#计算需要设置的分页数
                if($AllPages<=10):
                    for($i=1;$i<=$AllPages;$i++):
            ?>
                <li><a href="./ShowNews.php?pages=<?= $i; ?>"><?= $i;?></a></li>  //这个部分为页码显示，用GET方法来传输，来获取当前的页码值
            <?php
                    endfor;
                endif;
?>

