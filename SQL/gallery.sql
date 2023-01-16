-- 画廊管理员

-- 添加艺术品
create proc Gallery.addArtwk
	@name varchar(30),
	@type varchar(10),
	@cyear varchar(4),
	@price money,
	@artistid varchar(20),
	@gid varchar(20) = NULL
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);--将名字转为拼音
	select @num = 1000 * RAND();--随机一个序号
	select @id += CONVERT(varchar(3),@num);--组成ID
	insert into ARTWORK(ARTID,ARTTITLE,ARTYEAR,ARTTYPE,ARTPRICE,ARTISTID,GID)
	values(@id,@name,@cyear,@type,@price,@artistid,@gid);
go

-- 删除艺术品
create proc Gallery.rmArtwk
	@aid varchar(20)
	as
	declare @artistid varchar(20), @eid varchar(20), @n int;
	select @eid = EID, @artistid = ARTISTID from ARTWORK where ARTID = @aid;
	select @n = COUNT(*) from ARTWORK where EID = @eid and ARTISTID = @artistid;
	if @n <= 1 begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
	delete from ARTWORK where ARTID = @aid;
go

-- 修改艺术品信息√
create proc Gallery.alterArtwkInfo
	@name varchar(30),
	@type varchar(10),
	@cyear varchar(4),
	@price money,
	@artid varchar(20)
	as
	update ARTWORK set ARTPRICE = @price,ARTTITLE = @name,ARTYEAR = @cyear,ARTTYPE = @type
	where ARTID = @artid;
go

-- 与艺术家签约√
create proc Gallery.makeContrack
	@artistid varchar(20),
	@gid varchar(20)
	as
	update ARTIST set GID = @gid where ARTISTID = @artistid;
	update ARTWORK set GID = @gid where ARTISTID = @artistid;
go

-- 与艺术家解约√
create proc Gallery.breakContrack
	@gid varchar(20),
	@artistid varchar(20),
	@success char(1) OUTPUT
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		select @success = '2';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		select @success = '1';
	end
go

-- 一键查询本画廊订单
create proc Gallery.showOrder
	@gid varchar(20)
	as
	select TRADEID as 订单号, PRICE 交易金额, CID as 顾客号, CNAME 姓名, ARTID 作品号,
	ARTNAME 作品名, TRADEDATE 日期, TRADESTATUS 订单状态状态, GID 交易画廊号
	from TRADE 
	where GID  = @gid;
go

-- 办展览√
create proc Gallery.holdExhibition
	@gid varchar(20),
	@startdate date,
	@enddate date,
	@name varchar(30),
	@eid varchar(20) OUTPUT
	as
	declare @num decimal(3,0);
	select @eid = guest.procGetPY(@name);
	select @num = 1000 * RAND()
	select @eid += CONVERT(varchar(3),@num);
	-- print @eid
	insert into EXHIBITION(EID,ESTARTDATE,EENDDATE,GID,ENAME)
	values(@eid,@startdate,@enddate,@gid,@name);
go

-- 将需要添加进本次展览的作品的EID修改位本次展览号
create proc Gallery.pickArtwkForExb
	@artid varchar(20),
	@eid varchar(20)
	as
	update ARTWORK set EID = @eid where ARTID = @artid;
	declare @artistid varchar(20)
	select @artistid = ARTISTID from EXB_ARTIST where EID = @eid;
	if @artistid is null begin
		select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
		insert into EXB_ARTIST(EID,ARTISTID) values(@eid,@artistid);
	end
go

-- 从展览删除某件作品√
create proc Gallery.rmvArtwkFromExb
	@artid varchar(20),
	@eid varchar(20)
	as
	declare @artistid varchar(20);
	select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
	if exists(select * from ARTWORK where ARTISTID = @artistid) begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
go

-- 结束展览√
create proc Gallery.endExhibition
	@gid varchar(20),
	@eid varchar(20)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
go

-- 画廊注销√
create proc Gallery.logoff
	@gid varchar(20)
	as
	if exists(select * from EXHIBITION where GID = @gid and (ESTARTDATE < GETDATE() and EENDDATE > GETDATE())) begin
		print '当前有展览没有办完，不能注销！'
	end
	else begin
	-- 所有艺术家失业
	update ARTIST set GID = NULL where GID = @gid;
	-- 所有作品GID字段修改未NULL
	update ARTWORK set GID = NULL where GID = @gid;
	-- GALLERY表删除操作由系统管理员执行
	end
go

-- 修改订单状态
create proc Gallery.alterOrderStatus
	@tid varchar(20),
	@status char(6)
	as
	declare @aid varchar(20);
	select @aid = ARTID from TRADE where TRADEID = @tid;
	if(@status = '建立') begin
		update ARTWORK set ARTSTATUS = '已出售' where ARTID = @aid; end
	else if(@status = '取消') begin
		update ARTWORK set ARTSTATUS = '正常' where ARTID = @aid; end
	update TRADE set TRADESTATUS = @status where TRADEID = @tid;
go

-- 创建顾客参展记录
create proc Gallery.createCustRecord
	@cid varchar(20),
	@eid varchar(20)
	as
	insert into CUST_RECORD(EID,CID)
	values(@eid,@cid);
go
