var _wrapper = document.querySelector(".wrapper");
var _contain = document.querySelector(".contain");
var _btn = document.querySelector(".btn");
//下一张按钮
var _nextPic = document.querySelector(".wrapper a:nth-of-type(2)");
// 上一张按钮
var _prevPic = document.querySelector(".wrapper a:nth-of-type(1)");

var _btn = document.querySelector(".btn");
//获取所有小圆点
var _spots = document.querySelectorAll(".btn span");


// 下一张
_nextPic.onclick = function () {
    next_pic();
}
var index = 0;
function next_pic() {
    _contain.style.left = _contain.offsetLeft - 900 + "px";
    if (_contain.offsetLeft <= -4500) {
        _contain.style.left = 0;
    }
    index++;
    if (index > 4) {
        index = 0;
    }
    spots();
}

// 上一张
_prevPic.onclick = function () {
    prev_pic();
}
function prev_pic() {
    _contain.style.left = _contain.offsetLeft + 600 + "px";
    if (_contain.offsetLeft > 0) {
        _contain.style.left = -3600 + "px";
    }
    index--;
    if (index < 0) {
        index = 4;
    }
    spots();
}

//自动轮播
autoplay();
var id;
function autoplay() {
    id = setInterval(function () {
        next_pic();
    }, 2000)
}

//小圆点变化
function spots() {
    for (var i = 0; i < _spots.length; i++) {
        if (i == index) {
            _spots[i].className = "active"
        } else {
            _spots[i].className = ""
        }
    }
}

//悬停控制
_wrapper.onmouseover = function () {
    clearInterval(id);
}
_wrapper.onmouseout = function () {
    autoplay();
}


//悬浮小圆点更新图片
_btn.onmouseover = function (event) {
    //获取悬浮的小圆点
    var target = event.srcElement || event.target;
    if (target.nodeName == 'SPAN') {
        //查询小圆点下标
        var n = Array.from(_spots).findIndex(function (tag) {
            return tag == target
        })
        //更新下标
        index = n;
        //更新位移
        _contain.style.left = -900 * n + "px";
        //更新颜色
        spots();
    }
}