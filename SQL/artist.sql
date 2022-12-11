-- 艺术家的特权操作

-- 查询自己作品历史交易记录
create proc Artist.showOrder
	@artistid varchar(10)
	as
	select TRADEID as 订单号,CID as 顾客号,CNAME 姓名,ARTID 作品号,
	ARTNAME 作品名,TRADEDATE 日期,TRADESTATUS 订单状态状态,GID 交易画廊号
	from TRADE 
	where ARTID in (select ARTID from ARTWORK where ARTISTID  = @artistid)
go

-- 更改自己的个人信息
create proc Artist.alterArtistInfo
	@id varchar(10),
	@name varchar(20),
	@bp varchar(40),
	@style varchar(20)
	as
	update ARTIST set ARTISTNAME = @name,ARTISTBP = @bp,
	ARTISTSTYLE = @style where ARTISTID = @id;
go

-- 下架自己的艺术品
create proc Artist.noSellArtwk
	@artid varchar(10),
	@artistid varchar(10)
	as
	update ARTWORK set GID = NULL where ARTID = @artid and ARTISTID = @artistid;
go

-- 解约画廊
create proc Artist.breakContrack
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
-- 注销操作由系统管理员完成
create proc Artist.logoff
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '您当前有作品正在展览，不能注销，请待展览结束后进行注销!';
	end
	-- else begin
		-- 级联删除作品
		-- delete from ARTIST where ARTISTID = @artistid;
		-- ARTIST表删除操作由系统管理员执行
	-- end
go
