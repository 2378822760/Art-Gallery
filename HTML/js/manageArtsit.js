function toSign(){
    // var lb = document.getElementById('le');
    // var ipt = document.getElementById('Exhibition');
    // lb.setAttribute('style','display: none')
    // ipt.setAttribute('style','display: none')
    var btn = document.getElementById('gbt');
    btn.setAttribute('onclick',"query('queryResult','../../php/signArtist.php')");
    var box = document.getElementById('queryResult');
    box.innerHTML = '';
}

function toBreak(){
    // 获取查询gallery的相关组件并隐藏
    // var lb = document.getElementById('le');
    // var ipt = document.getElementById('Exhibition');
    // lb.setAttribute('style','display: initial')
    // ipt.setAttribute('style','display: initial')
    // 更改按钮行为
    var btn = document.getElementById('gbt');
    btn.setAttribute('onclick',"query('queryResult','../../php/breakArtist.php')");
    // 清除已有内容
    var box = document.getElementById('queryResult');
    box.innerHTML = '';
}