window.onload = function(){
    changeLoginMode();
};

function changeLoginMode(){
    // 获取所有label标签和table标签
    // label标签代表选项卡，table标签是三个注册页面
    var lb = document.getElementsByClassName('select');
    var tb = document.getElementsByClassName('respectiveField')
    var lbName = [["bp","style","gname","location"],["address","phonenum","gname","location"],["address","phonenum","bp","style"]];
    var checkName = [["address","phonenum"],["bp","style"],["gname","location"]];
    // 遍历所有label标签，为每个label标签绑定函数
    for(var i = 0;i < lb.length;i++){
        lb[i].index = i;
        // 先将所有table隐藏，再将该标签对应的注册页面显示
        lb[i].onfocus = function (){
            var tmp = document.getElementById('name')
            if (this.id != 'sgallery'){
                tmp.style.display = 'flex';
            }
            else{
                tmp.style.display = 'none';
            }
            tmp = lbName[this.index];
            for(var i = 0;i < tmp.length;i++){
                document.getElementsByName(tmp[i])[0].setAttribute('formnovalidate','');
            }
            tmp = checkName[this.index];
            for(var i = 0;i < tmp.length;i++){
                document.getElementsByName(tmp[i])[0].removeAttribute('formnovalidate');
            }
            for(var i = 0;i < tb.length;i++){
                tb[i].style.display = 'none';
            }
            tb[this.index].style.display = 'block';
        };
    }
}



