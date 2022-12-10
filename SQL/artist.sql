-- �����ҵ���Ȩ����

declare @artistid varchar(10);
declare @artistname varchar(20);
declare @artistbp varchar(40);
declare @artiststyle varchar(20);

-- ��ѯ�Լ���Ʒ��ʷ���׼�¼
select * from TRADE where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '���׽���' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '���׽���' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '������' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '������' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = '���' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = '���' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;
select * from TRADE where TRADESTATUS = 'ȡ��' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE ASC;
select * from TRADE where TRADESTATUS = 'ȡ��' and ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid) order by TRADEDATE DESC;

-- �����Լ��ĸ�����Ϣ
update ARTIST set ARTISTNAME = @artistname,ARTISTBP = @artistbp,
ARTISTSTYLE = @artiststyle where ARTISTID = @artistid;

-- �¼��Լ�������Ʒ
declare @artid varchar(10);
update ARTWORK set GID = NULL where ARTID = @artid and ARTISTID = @artistid;
go

-- ��Լ����
create proc breakContrack
	@gid varchar(10),
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '����ǰ����Ʒ����չ�������ܽ�Լ�����չ����������н�Լ!';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		print '��Լ�ɹ�';
	end
go

-- ������ע��
create proc logoff
	@artistid varchar(10)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '����ǰ����Ʒ����չ��������ע�������չ�����������ע��!';
	end
	else begin
		-- ����ɾ����Ʒ
		delete from ARTIST where ARTISTID = @artistid;
		-- ARTIST��ɾ��������ϵͳ����Աִ��
	end
go