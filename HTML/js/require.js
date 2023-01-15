function require(target,message) {
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    } else { // code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    // var returnMessage = "Nothing return";
    xmlhttp.onreadystatechange=function() {
        if (this.readyState==4 && this.status==200) {
            // returnMessage=this.responseText;
            var status = this.responseText;
            if (status == 'success'){
                alert('success');
            }
            else{
                alert('出错了请重试')
            }
        }
    }
    xmlhttp.open("POST", target, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send(message);
    // while (xmlhttp.status != 200);
    // return returnMessage;
} 