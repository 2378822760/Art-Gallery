declare @id varchar(10),@name varchar(20),@address varchar(40),@ob date,@phone varchar(11);
declare @satisf int, @eid varchar(10);

-- ��ѯ��ʷ���׼�¼
select * from TRADE where CID = @id order by TRADEDATE ASC;
select * from TRADE where CID = @id order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '���׽���' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '���׽���' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '������' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '������' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = '���' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = '���' order by TRADEDATE DESC;
select * from TRADE where CID = @id and TRADESTATUS = 'ȡ��' order by TRADEDATE ASC;
select * from TRADE where CID = @id and TRADESTATUS = 'ȡ��' order by TRADEDATE DESC;

-- �޸ĸ�����Ϣ
update CUSTOMER set CNAME = @name,CADDRESS = @address,CDOB = @ob,CPHONE = @phone
where CID = @id;

-- ����ĳ�����۽��
update CUST_RECORD set SATISFACTION = @satisf where CID = @id and EID = @eid;
go
-- ��ѯĳ��չ������������
create proc query_satisf
	@eid varchar(10)
	as
	declare @sum int
	select @sum = COUNT(*) from CUST_RECORD where EID = @eid
	select SATISFACTION as ����ȼ�, count(*) as ����,1.0 * count(*) / @sum as ���� from CUST_RECORD where EID = @eid
	group by SATISFACTION
go
exec query_satisf 'H001';
drop proc query_satisf;
go

-- �û�ע��
-- ûʲôҪ���ģ�CUSTOMER����ϵͳ����Աά��