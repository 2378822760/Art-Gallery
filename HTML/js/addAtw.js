function add() {
    var res = confirm("确认添加？");
    if (!res){
        return;
    }
    var atwname = document.getElementById('atwname').value;
    var atwtype = document.getElementById('atwtype').value;
    var atwyear = document.getElementById('atwyear').value;
    var atwprice = document.getElementById('atwprice').value;
    var artisID = document.getElementById('artisID').value;
    var message = "n=" + atwname + "&t=" + atwtype + "&y=" + atwyear + "&p=" + atwprice + "&aid=" + artisID;
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    } else { // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (this.readyState==4 && this.status==200) {
            window.alert(this.responseText);
            if (this.responseText == 'success'){
                var res = confirm("添加成功是否继续添加？点击取消会关闭当前页面");
                if (!res){
                    window.close();
                }
            }
        }
    }
    xmlhttp.open("POST", '../../php/addAtw.php', true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send(message);
}