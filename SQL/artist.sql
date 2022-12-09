-- 艺术家的特权操作

declare @artistid varchar(10);
declare @artistname varchar(20);
declare @artistbp varchar(40);
declare @artiststyle varchar(20);

-- 查询自己作品历史交易记录
select * from TRADE where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '交易建立' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '交易建立' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '运输中' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '运输中' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '完成' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '完成' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '取消' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '取消' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;

-- 更改自己的个人信息
update ARTIST set ARTISTNAME = @artistname,ARTISTBP = @artistbp,
ARTISTSTYLE = @artiststyle where ARTISTID = @artistid;

-- 下架自己的艺术品
declare @artid varchar(10);
update ARTWORK set GID = NULL where ARTID = @artid and ARTISTID = @artistid;
go

-- 解约画廊
create proc breakContrack
	@gid varchar(10),
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '您当前有作品正在展览，不能解约，请待展览结束后进行解约!';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		print '解约成功';
	end
go

-- 艺术家注销
create proc logoff
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '您当前有作品正在展览，不能注销，请待展览结束后进行注销!';
	end
	else begin
		-- 级联删除作品
		delete from ARTIST where ARTISTID = @artistid;
		-- ARTIST表删除操作由系统管理员执行
	end
go