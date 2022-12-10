declare @id varchar(10),@name varchar(20),@address varchar(40),@ob date,@phone varchar(11);
declare @satisf int, @eid varchar(10);

-- 查询历史交易记录
select * from TRADE where CID = @id order by TRADEDATE ASC;
select * from TRADE where CID = @id order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '交易建立' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '交易建立' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '运输中' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '运输中' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '完成' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '完成' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '取消' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '取消' order by TRADEDATE DESC;

-- 修改个人信息
update CUSTOMER set CNAME = @name,CADDRESS = @address,CDOB = @ob,CPHONE = @phone
where CID = @id;

-- 更新某次评价结果
update CUST_RECORD set SATISFACTION = @satisf where CID = @id and EID = @eid;
go
-- 查询某次展览的满意度情况
create proc query_satisf
	@eid varchar(10)
	as
	declare @sum int
	select @sum = COUNT(*) from CUST_RECORD where EID = @eid
	select SATISFACTION as 满意等级, count(*) as 总数,1.0 * count(*) / @sum as 比例 from CUST_RECORD where EID = @eid
	group by SATISFACTION
go
exec query_satisf 'H001';
drop proc query_satisf;
go

-- 用户注销
-- 没什么要做的，CUSTOMER表由系统管理员维护