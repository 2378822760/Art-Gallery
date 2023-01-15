function gotoBuy(goodsId) {
    var res = confirm("确认购买?");
    if(!res)
        return;
    var obj = document.getElementById(goodsId);
    var aid = obj.cells[0].innerHTML;
    var gid = obj.cells[7].innerHTML;
    var message = "../../html/customer/order.html?aid=" + aid + "&gid=" + gid;
    window.open(encodeURI(message));
}