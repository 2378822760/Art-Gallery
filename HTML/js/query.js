function show(Id,target,message) {
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    } else { // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function() {
        if (this.readyState==4 && this.status==200) {
        document.getElementById(Id).innerHTML=this.responseText;
        }
    }
    xmlhttp.open("POST", target, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send(message);
} 

function query(Id,target) {
    var radio = document.getElementsByName('Query');
    var mode = '1';
    var ipt = document.getElementById('key');
    // console.log(ipt.value);
    for(var i = 0;i < radio.length;i++){
        if (radio[i].checked) {
            mode = radio[i].value;
        }
    }
    var message = 'Query=' + mode + '&content=' + ipt.value;
    // console.log(message);
    show(Id,target,message);
}

