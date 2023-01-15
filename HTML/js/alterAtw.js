function alter(artwkID){
    var obj = document.getElementById(artwkID);
    for(var i = 1;i < 5;i++){
        obj.cells[i].setAttribute("contenteditable",'true');
    }
    obj.cells[9].innerHTML = "<a href='javaScript:void(0)' onclick='confirmAlter(" + artwkID + ")'>确认</a>";
}

function confirmAlter(artwkID){
    var res = confirm("确认修改?");
    if(!res)
        return;
    var obj = document.getElementById(artwkID);
    for(var i = 1;i < 5;i++){
        obj.cells[i].setAttribute("contenteditable",'false');
    }
    obj.cells[9].innerHTML = "<a href='javaScript:void(0)' onclick='alter(" + artwkID + ")'>修改</a>";
    var arr = [];
    for(var i = 0;i < 5;i++){
        arr.push(obj.cells[i].innerHTML);
    }
    var message = "mode=1" + "&aid=" + arr[0] + "&aname=" + arr[1] + "&atype=" + arr[2] + "&ayear=" + arr[3] + "&aprice=" + arr[4].slice(1,);
    require('../../php/alterAtw.php',message);
    // if (reruenMessage == 'success'){
    //     window.alert('修改成功');
    // }
    // else{
    //     window.alert(reruenMessage);
    //     // window.alert('出错啦！请重试');
    // }
}

function remove(artwkID){
    var res = confirm("确认删除这个艺术品吗？删除就再也没有了哦");
    if (!res){
        return;
    }

}