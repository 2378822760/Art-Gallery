-- 画廊管理员


-- 添加艺术品
create proc Gallery.addArtwk
	@name varchar(20),
	@type varchar(10),
	@cyear varchar(20),
	@price money,
	@artistid varchar(10),
	@gid varchar(10) = NULL
	as
	declare @id varchar(10), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into ARTWORK(ARTID,ARTTITLE,ARTTYPE,ARTTYPE,ARTPRICE,ARTISTID,GID)
	values(@id,@name,@cyear,@type,@price,@artistid,@gid);
go

-- 修改艺术品信息√
create proc Gallery.alterArtwkInfo
	@name varchar(20),
	@type varchar(10),
	@cyear varchar(20),
	@price money,
	@artid varchar(10)
	as
	update ARTWORK set ARTPRICE = @price,ARTTITLE = @name,ARTTYPE = @cyear,ARTTYPE = @type
	where ARTID = @artid;
go

-- 与艺术家签约√
create proc Gallery.makeContrack
	@artistid varchar(10),
	@gid varchar(10)
	as
	update ARTIST set GID = @gid where ARTISTID = @artistid;
	update ARTWORK set GID = @gid where ARTISTID = @artistid;
go

-- 与艺术家解约√
create proc Gallery.breakContrack
	@gid varchar(10),
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '该艺术家当前有作品正在展览，不能解约，请待展览结束后进行解约!';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		print '解约成功';
	end
go

-- 一键查询本画廊订单
create proc Gallery.showOrder
	@gid varchar(10)
	as
	select TRADEID as 订单号,CID as 顾客号,CNAME 姓名,ARTID 作品号,
	ARTNAME 作品名,TRADEDATE 日期,TRADESTATUS 订单状态状态,GID 交易画廊号
	from TRADE 
	where GID  = @gid;
go

-- 办展览√
create proc Gallery.holdExhibition
	@gid varchar(10),
	@startdate date,
	@enddate date,
	@name varchar(10)
	as
	declare @eid varchar(10), @num decimal(3,0);
	select @eid = dbo.procGetPY(@name);
	select @num = 1000 * RAND()
	select @eid += CONVERT(varchar(3),@num);
	-- print @eid
	insert into EXHIBITION(EID,ESTARTDATE,EENDDATE,GID,ENAME)
	values(@eid,@startdate,@enddate,@gid,@name);
go

-- 将需要添加进本次展览的作品的EID修改位本次展览号
-- for artworkid in idlist:
-- declare @eid varchar(10), @artid varchar(10);
-- update ARTWORK set EID = @eid where ARTID = @artid;
-- 修改EXB_ARTIST
-- insert into EXB_ARTIST(EID,ARTISTID) select EID,ARTISTID from ARTWORK where EID = @eid;
-- go

create proc Gallery.pickArtwkForExb
	@artid varchar(10),
	@eid varchar(10)
	as
	update ARTWORK set EID = @eid where ARTID = @artid;
	declare @artistid varchar(10)
	select @artistid = ARTISTID from EXB_ARTIST where EID = @eid;
	if @artistid is null begin
		insert into EXB_ARTIST(EID,ARTISTID) values(@eid,@artistid);
	end
go

-- 从展览删除某件作品√
create proc Gallery.rmvArtwkFromExb
	@artid varchar(10),
	@eid varchar(10)
	as
	declare @artistid varchar(10);
	select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
	if exists(select * from ARTWORK where ARTISTID = @artistid) begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
go

-- 结束展览√
create proc Gallery.endExhibition
	@gid varchar(10),
	@eid varchar(10)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
go

-- 画廊注销√
create proc Gallery.logoff
	@gid varchar(10)
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


-- 创建订单

