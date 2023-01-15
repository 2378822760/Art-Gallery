window.onload = function(){
    var url= decodeURI(document.URL);
    var params = getQueryParams(url);
    var message = 'aid=' + params.aid + '&gid=' + params.gid + '&cancel=0';
    show('order','../../php/order.php',message);
};

function getQueryParams(url) {
    const paramArr = url.slice(url.indexOf("?") + 1).split("&");
    const params = {};
    paramArr.map((param) => {
        const [key, val] = param.split("=");
        params[key] = decodeURIComponent(val);
    });
    return params;
}

function concelOrder() {
    var res = confirm("确认取消订单？");
    if (!res){
        return;
    }
    var obj = document.getElementById('key');
    var message = 'cancel=1&tid=' + obj.innerHTML;
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    } else { // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (this.readyState==4 && this.status==200) {
            if (this.responseText == 'success'){
                var res = confirm("取消订单成功！点击确定关闭当前页面");
                if (res){
                    window.close();
                }
            }
            else{
                window.alert("出错了，请重试");
            }
        }
    }
    xmlhttp.open("POST", '../php/order.php', true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send(message);
}
