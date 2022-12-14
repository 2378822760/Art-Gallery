-- 顾客的特权指令

-- 查询历史交易记录
create proc Customer.showOrder
	@cid varchar(20)
	as
	select TRADEID 订单号, PRICE 交易金额, CID 顾客号, CNAME 姓名, ARTID 作品号, ARTNAME 作品名, TRADEDATE 日期, TRADESTATUS 订单状态, GID 交易画廊号
	from TRADE 
	where CID = @cid;
go

-- 修改个人信息
create proc Customer.alterCstmInfo
	@id varchar(20),
	@name varchar(30),
	@address varchar(40),
	@birth date,
	@phonenumber varchar(11)
	as
	update CUSTOMER set CNAME = @name, CADDRESS = @address, CDOB = @birth, CPHONE = @phonenumber
	where CID = @id;
go

-- 更新某次评价结果
create proc Customer.alterAssessLv
	@eid varchar(20),
	@cid varchar(20),
	@lv smallint
	as
	update CUST_RECORD set SATISFACTION = @lv where CID = @cid and EID = @eid;
go

-- 查询某次展览的满意度情况
create proc Customer.showSatisfy
	@eid varchar(20)
	as
	declare @sum int
	select @sum = COUNT(*) from CUST_RECORD where EID = @eid
	select SATISFACTION as 满意等级, count(*) as 总数,1.0 * count(*) / @sum as 比例 from CUST_RECORD where EID = @eid
	group by SATISFACTION
go

-- 创建订单
create proc Customer.createOrder
	@cid varchar(20),
	@aid varchar(20),
	@gid varchar(20)
	as
	declare @tid char(16), @price money, @cname varchar(30), @aname varchar(20);
	declare @a decimal(8,0) = rand() * 100000000;
	declare @b SMALLDATETIME = getdate();
	set @tid = DATENAME(YEAR,@b) + DATENAME(MONTH,@b) + DATENAME(DAY,@b) + CONVERT(char(8),@a)
	select @price = ARTPRICE, @aname = ARTTITLE from ARTWORK where ARTID = @aid;
	select @cname = CNAME from CUSTOMER where CID = @cid;
	insert into TRADE(TRADEID,PRICE,CID,CNAME,ARTID,ARTNAME,TRADEDATE,TRADESTATUE,GID)
	values(@tid,@price,@cid,@cname,@aid,@aname,@b,'建立',@gid);
go

-- 注销操作由系统管理员完成，用户不能自行随意注销
