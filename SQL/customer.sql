-- 消费者的特权指令

-- 查询历史交易记录
create proc Customer.showOoder
	@cid varchar(10)
	as
	select TRADEID as 订单号,CID as 顾客号,CNAME 姓名,ARTID 作品号,
	ARTNAME 作品名,TRADEDATE 日期,TRADESTATUS 订单状态状态,GID 交易画廊号
	from TRADE 
	where CID = @cid;
go

-- 修改个人信息
create proc Customer.alterCstmInfo
	@id varchar(10),
	@name varchar(20),
	@address varchar(40),
	@birth date,
	@phonenumber varchar(20)
	as
	update CUSTOMER set CNAME = @name,CADDRESS = @address,CDOB = @birth,CPHONE = @phonenumber
	where CID = @id;
go

-- 更新某次评价结果
create proc Customer.alterAssessLv
	@eid varchar(10),
	@cid varchar(10),
	@lv smallint
	as
	update CUST_RECORD set SATISFACTION = @lv where CID = @cid and EID = @eid;
go

-- 查询某次展览的满意度情况
create proc Customer.showSatisfy
	@eid varchar(10)
	as
	declare @sum int
	select @sum = COUNT(*) from CUST_RECORD where EID = @eid
	select SATISFACTION as 满意等级, count(*) as 总数,1.0 * count(*) / @sum as 比例 from CUST_RECORD where EID = @eid
	group by SATISFACTION
go

-- 用户注销
-- 没什么要做的，CUSTOMER表由系统管理员维护
