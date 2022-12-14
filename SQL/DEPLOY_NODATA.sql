--һ�����𣬵��������ʼ����
create database AG
go

--����������
--����
use AG
CREATE TABLE GALLERY
(
    GID VARCHAR(20) PRIMARY KEY,
    GNAME VARCHAR(30),
    GLOCATION VARCHAR(40)
);

--�˿�
CREATE TABLE CUSTOMER
(
    CID VARCHAR(20) PRIMARY KEY,
    CNAME VARCHAR(30),
    CADDRESS VARCHAR(40),
    CDOB DATE,
    CPHONE VARCHAR(11)
);

--������
CREATE TABLE ARTIST
(
    ARTISTID VARCHAR(20) PRIMARY KEY,
    ARTISTNAME VARCHAR(30),
    ARTISTBP VARCHAR(40),
    ARTISTSTYLE VARCHAR(20),
    GID VARCHAR(20),
	FOREIGN KEY(GID) REFERENCES GALLERY(GID) ON DELETE SET NULL
);

--չ��
CREATE TABLE EXHIBITION
(
    EID VARCHAR(20) PRIMARY KEY,
    ESTARTDATE DATE,
    ENAME VARCHAR(30),
    EENDDATE DATE,
    GID VARCHAR(20)
);

--����Ʒ
CREATE TABLE ARTWORK
(
    ARTID VARCHAR(20) PRIMARY KEY,
    ARTTITLE VARCHAR(20),
    ARTTYPE VARCHAR(10),
    ARTYEAR VARCHAR(4),
    ARTPRICE MONEY,
    ARTSTATUS VARCHAR(10) DEFAULT('����'),
    ARTISTID VARCHAR(20),
    GID VARCHAR(20),
    EID VARCHAR(20),
    FOREIGN KEY(ARTISTID) REFERENCES ARTIST(ARTISTID) ON DELETE CASCADE,
    FOREIGN KEY(GID) REFERENCES GALLERY(GID) ON DELETE SET NULL,
    FOREIGN KEY(EID) REFERENCES EXHIBITION(EID),
    CHECK(ARTSTATUS IN ('����','չʾ��','�ѳ���')),--����Ʒ״̬����ȡ����֮һ
    CHECK(ARTPRICE > 0)
);

--��չ����ȵ���
CREATE TABLE CUST_RECORD
(
    EID VARCHAR(20),
    CID VARCHAR(20),
    SATISFACTION SMALLINT,
    PRIMARY KEY(EID,CID),
    CHECK(SATISFACTION>0 AND SATISFACTION<=5)
);

--��չ������
CREATE TABLE EXB_ARTIST
(
    EID VARCHAR(20),
    ARTISTID VARCHAR(20),
    PRIMARY KEY(EID,ARTISTID),
    FOREIGN KEY(EID) REFERENCES EXHIBITION(EID),
    FOREIGN KEY(ARTISTID) REFERENCES ARTIST(ARTISTID) ON DELETE CASCADE
);

--���׼�¼
CREATE TABLE TRADE
(
    TRADEID VARCHAR(20) PRIMARY KEY,
	PRICE MONEY,
    CID VARCHAR(20),
	CNAME VARCHAR(30),
    ARTID VARCHAR(20),
	ARTNAME VARCHAR(30),
    TRADEDATE DATE,
    TRADESTATUS VARCHAR(10) DEFAULT('����'),
    GID VARCHAR(20), --ʹ���ȹ�����Ա�ܹ�����GID���ٲ�ѯ�Լ����Ƚ�����Ϣ
    CHECK(TRADESTATUS IN ('����','������','�����','ȡ��'))
);
go

-- �������ݿ��ɫ
use AG
go
CREATE ROLE R_MANAGER;
CREATE ROLE R_CUSTOMER;
CREATE ROLE R_ARTIST;
CREATE ROLE R_GALLERY;
go

-- Ϊϵͳ����Ա����Ȩ��
GRANT ALL PRIVILEGES
ON ARTIST TO R_MANAGER;
GRANT ALL PRIVILEGES
ON CUSTOMER TO R_MANAGER;
GRANT ALL PRIVILEGES
ON GALLERY TO R_MANAGER;
GRANT ALL PRIVILEGES
ON EXHIBITION TO R_MANAGER;
GRANT ALL PRIVILEGES
ON EXB_ARTIST TO R_MANAGER;
GRANT SELECT
ON CUST_RECORD TO R_MANAGER;
GRANT SELECT 
ON TRADE TO R_MANAGER;
GRANT ALL PRIVILEGES
ON ARTWORK TO R_MANAGER;

-- Ϊ��ɫ�˿ͷ���Ȩ��
GRANT SELECT
ON ARTIST TO R_CUSTOMER;
GRANT SELECT, INSERT
ON TRADE TO R_CUSTOMER;
GRANT SELECT
ON GALLERY TO R_CUSTOMER;
GRANT SELECT
ON EXHIBITION TO R_CUSTOMER;
GRANT SELECT
ON EXB_ARTIST TO R_CUSTOMER;
GRANT SELECT, UPDATE(CNAME,CADDRESS,CDOB,CPHONE)
ON CUSTOMER TO R_CUSTOMER;
GRANT SELECT
ON ARTWORK TO R_CUSTOMER;
GRANT SELECT, UPDATE(SATISFACTION)
ON CUST_RECORD TO R_CUSTOMER;
go

-- Ϊ�����ҷ���Ȩ��
GRANT SELECT, UPDATE(ARTISTNAME,ARTISTBP,ARTISTSTYLE,GID)
ON ARTIST TO R_ARTIST;
GRANT SELECT
ON TRADE TO  R_ARTIST;
GRANT SELECT
ON GALLERY TO R_ARTIST;
GRANT SELECT
ON EXHIBITION TO  R_ARTIST;
GRANT SELECT
ON EXB_ARTIST TO  R_ARTIST;
GRANT SELECT
ON ARTWORK TO  R_ARTIST;
GRANT SELECT
ON CUST_RECORD TO  R_ARTIST;
go

-- Ϊ���ȹ���Ա����Ȩ��
GRANT SELECT, UPDATE(GID)
ON ARTIST TO R_GALLERY;
GRANT SELECT, UPDATE(TRADESTATUES)
ON TRADE TO  R_GALLERY;
GRANT SELECT
ON GALLERY TO R_GALLERY;
GRANT SELECT, UPDATE(ESTARTDATE,ENAME,EENDDATE), INSERT
ON EXHIBITION TO  R_GALLERY;
GRANT SELECT, INSERT, DELETE
ON EXB_ARTIST TO  R_GALLERY;
GRANT SELECT, INSERT, UPDATE(ARTTITLE,ARTTYPE,ARTYEAR,ARTPRICE,ARTSTATUS,GID,EID)
ON ARTWORK TO  R_GALLERY;
GRANT SELECT, INSERT
ON CUST_RECORD TO  R_GALLERY;
go

-- ʹ��SQL��������¼�˻�
-- �﷨��ʽ����:
-- sp_addlogin '��¼�˻���','��½����','Ĭ�����ݿ�','Ĭ������'
-- ɾ���﷨��ʽ���£�
-- sp_droplogin '��¼�˻���'
-- ע��һ�����ȹ���Ա��һ�������ң�һ���˿�
-- ���ǵķ�������ɫ��Ϊpublic
use AG
go
exec sp_addlogin 'Manager','123','AG'
exec sp_addlogin 'Gallery','123','AG'
exec sp_addlogin 'Artist','123','AG'
exec sp_addlogin 'Customer','123','AG'
go

-- �����͵�¼����Ӧ�����ݿ��û�
-- �﷨��ʽ���£�
-- sp_grantdbaccess '��½�û���','���ݿ��û���'
-- ���ݿ��û���ȱʧĬ��δ��¼�û���
-- ɾ���﷨����:
-- sp_revokedbacces '���ݿ��û���'
exec sp_grantdbaccess 'Manager'
exec sp_grantdbaccess 'Gallery'
exec sp_grantdbaccess 'Artist'
exec sp_grantdbaccess 'Customer'
go

-- Ϊ�����ݿ��û������ݿ��ɫӳ��
exec sp_addrolemember R_MANAGER, Manager;
exec sp_addrolemember R_GALLERY, Gallery;
exec sp_addrolemember R_ARTIST, Artist;
exec sp_addrolemember R_CUSTOMER, Customer;
go

-- �����ҵ���Ȩ����

-- ��ѯ�Լ���Ʒ��ʷ���׼�¼
create proc Artist.showOrder
	@artistid varchar(20)
	as
	select TRADEID ������,  PRICE ���׽��, CID �˿ͺ�, CNAME ����, ARTID ��Ʒ��, ARTNAME ��Ʒ��, TRADEDATE ����, TRADESTATUS ����״̬״̬, GID ���׻��Ⱥ�
	from TRADE 
	where ARTID in (select ARTID from ARTWORK where ARTISTID  = @artistid)
go

-- �����Լ��ĸ�����Ϣ
create proc Artist.alterArtistInfo
	@id varchar(20),
	@name varchar(30),
	@bp varchar(40),
	@style varchar(10)
	as
	update ARTIST set ARTISTNAME = @name,ARTISTBP = @bp,
	ARTISTSTYLE = @style where ARTISTID = @id;
go

-- �¼��Լ�������Ʒ
create proc Artist.noSellArtwk
	@artid varchar(20),
	@artistid varchar(20)
	as
	update ARTWORK set GID = NULL where ARTID = @artid and ARTISTID = @artistid;
go

-- ��Լ����
create proc Artist.breakContrack
	@gid varchar(20),
	@artistid varchar(20)
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
-- ע��������ϵͳ����Ա���
create proc Artist.logoff
	@artistid varchar(20)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '����ǰ����Ʒ����չ��������ע�������չ�����������ע��!';
	end
	-- else begin
		-- ����ɾ����Ʒ
		-- delete from ARTIST where ARTISTID = @artistid;
		-- ARTIST��ɾ��������ϵͳ����Աִ��
	-- end
go

-- �˿͵���Ȩָ��

-- ��ѯ��ʷ���׼�¼
create proc Customer.showOrder
	@cid varchar(20)
	as
	select TRADEID ������, PRICE ���׽��, CID �˿ͺ�, CNAME ����, ARTID ��Ʒ��, ARTNAME ��Ʒ��, TRADEDATE ����, TRADESTATUS ����״̬, GID ���׻��Ⱥ�
	from TRADE 
	where CID = @cid;
go

-- �޸ĸ�����Ϣ
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

-- ����ĳ�����۽��
create proc Customer.alterAssessLv
	@eid varchar(20),
	@cid varchar(20),
	@lv smallint
	as
	update CUST_RECORD set SATISFACTION = @lv where CID = @cid and EID = @eid;
go

-- ��ѯĳ��չ������������
create proc Customer.showSatisfy
	@eid varchar(20)
	as
	declare @sum int
	select @sum = COUNT(*) from CUST_RECORD where EID = @eid
	select SATISFACTION as ����ȼ�, count(*) as ����,1.0 * count(*) / @sum as ���� from CUST_RECORD where EID = @eid
	group by SATISFACTION
go

-- ��������
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
	values(@tid,@price,@cid,@cname,@aid,@aname,@b,'����',@gid);
go

-- ע��������ϵͳ����Ա��ɣ��û�������������ע��

-- ���ȹ���Ա

-- �������Ʒ
create proc Gallery.addArtwk
	@name varchar(30),
	@type varchar(10),
	@cyear varchar(4),
	@price money,
	@artistid varchar(20),
	@gid varchar(20) = NULL
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);--������תΪƴ��
	select @num = 1000 * RAND();--���һ�����
	select @id += CONVERT(varchar(3),@num);--���ID
	insert into ARTWORK(ARTID,ARTTITLE,ARTYEAR,ARTTYPE,ARTPRICE,ARTISTID,GID)
	values(@id,@name,@cyear,@type,@price,@artistid,@gid);
go

-- �޸�����Ʒ��Ϣ��
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

-- ��������ǩԼ��
create proc Gallery.makeContrack
	@artistid varchar(20),
	@gid varchar(20)
	as
	update ARTIST set GID = @gid where ARTISTID = @artistid;
	update ARTWORK set GID = @gid where ARTISTID = @artistid;
go

-- �������ҽ�Լ��
create proc Gallery.breakContrack
	@gid varchar(20),
	@artistid varchar(20)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '�������ҵ�ǰ����Ʒ����չ�������ܽ�Լ�����չ����������н�Լ!';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		print '��Լ�ɹ�';
	end
go

-- һ����ѯ�����ȶ���
create proc Gallery.showOrder
	@gid varchar(20)
	as
	select TRADEID as ������, PRICE ���׽��, CID as �˿ͺ�, CNAME ����, ARTID ��Ʒ��,
	ARTNAME ��Ʒ��, TRADEDATE ����, TRADESTATUS ����״̬״̬, GID ���׻��Ⱥ�
	from TRADE 
	where GID  = @gid;
go

-- ��չ����
create proc Gallery.holdExhibition
	@gid varchar(20),
	@startdate date,
	@enddate date,
	@name varchar(30)
	as
	declare @eid varchar(20), @num decimal(3,0);
	select @eid = guest.procGetPY(@name);
	select @num = 1000 * RAND()
	select @eid += CONVERT(varchar(3),@num);
	-- print @eid
	insert into EXHIBITION(EID,ESTARTDATE,EENDDATE,GID,ENAME)
	values(@eid,@startdate,@enddate,@gid,@name);
go

-- ����Ҫ��ӽ�����չ������Ʒ��EID�޸�λ����չ����
create proc Gallery.pickArtwkForExb
	@artid varchar(20),
	@eid varchar(20)
	as
	update ARTWORK set EID = @eid where ARTID = @artid;
	declare @artistid varchar(20)
	select @artistid = ARTISTID from EXB_ARTIST where EID = @eid;
	if @artistid is null begin
		insert into EXB_ARTIST(EID,ARTISTID) values(@eid,@artistid);
	end
go

-- ��չ��ɾ��ĳ����Ʒ��
create proc Gallery.rmvArtwkFromExb
	@artid varchar(20),
	@eid varchar(20)
	as
	declare @artistid varchar(20);
	select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
	update ARTWORK set EID = NULL,ARTSTATUS = '����' where EID = @eid;
	if exists(select * from ARTWORK where ARTISTID = @artistid) begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
go

-- ����չ����
create proc Gallery.endExhibition
	@gid varchar(20),
	@eid varchar(20)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL,ARTSTATUS = '����' where EID = @eid;
go

-- ����ע����
create proc Gallery.logoff
	@gid varchar(20)
	as
	if exists(select * from EXHIBITION where GID = @gid and (ESTARTDATE < GETDATE() and EENDDATE > GETDATE())) begin
		print '��ǰ��չ��û�а��꣬����ע����'
	end
	else begin
	-- ����������ʧҵ
	update ARTIST set GID = NULL where GID = @gid;
	-- ������ƷGID�ֶ��޸�δNULL
	update ARTWORK set GID = NULL where GID = @gid;
	-- GALLERY��ɾ��������ϵͳ����Աִ��
	end
go

-- �޸Ķ���״̬
create proc Gallery.alterOrderStatus
	@tid varchar(20),
	@status char(6)
	as
	declare @aid varchar(20);
	select @aid = ARTID from TRADE where TRADEID = @tid;
	if(@status = '����') begin
		update ARTWORK set ARTSTATUS = '�ѳ���' where ARTID = @aid; end
	else if(@status = 'ȡ��') begin
		update ARTWORK set ARTSTATUS = '����' where ARTID = @aid; end
	update TRADE set TRADESTATUS = @status where TRADEID = @tid;
go

use AG
go
-- ARTIST
-- ������ע��
create proc Manager.loginArtist
	@name varchar(30),
	@bp varchar(40),
	@style varchar(10)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into ARTIST(ARTISTID,ARTISTNAME,ARTISTBP,ARTISTSTYLE)
	values(@id,@name,@bp,@style);
go

-- ʹ��������IDɾ��������
create proc Manager.logoffArtist
	@id varchar(20)
	as
	delete from ARTIST where ARTISTID = @id;
go

-- CUST_RECORD
-- ���ʼ�¼����


-- CUSTOMER
-- �˿�ע��
create proc Manager.loginCustomer
	@name varchar(30),
	@address varchar(40),
	@birth date,
	@phonenumber varchar(11)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into CUSTOMER(CID,CNAME,CADDRESS,CDOB,CPHONE)
	values(@id,@name,@address,@birth,@phonenumber)
go

-- ͨ���ͻ�IDɾ���ͻ�
create proc Manager.logoffCustomer
	@id varchar(20)
	as
	delete from CUSTOMER where CID = @id;
go

-- EXB_ARTIST
-- Ȩ���·�

-- EXHIBITION
-- չ����Ϣ����

-- GALLERY
-- ����ע��
create proc Manager.loginGallery
	@name varchar(30),
	@location varchar(40)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into GALLERY(GID,GNAME,GLOCATION)
	values(@id,@name,@location)
go

-- �����뿪ϵͳ��ͨ��GIDɾ������
-- �޸�GID�ֶ�ΪGALLERY������
create proc Manager.logoffGallery
	@id varchar(20)
	as
	declare @name varchar(30);
	select @name = GNAME from GALLERY where GID = @id;
	update EXHIBITION set GID = @name where GID = @id;
	delete from GALLERY where GID = @id;
go

-- ������Ϣ����



--������תΪƴ������ĸ��д����
Create FUNCTION guest.procGetPY(@str NVARCHAR(4000))
RETURNS NVARCHAR(4000) 
AS
BEGIN 
DECLARE @WORD NCHAR(1),@PY NVARCHAR(4000) 
SET @PY='' 
WHILE LEN(@STR)>0 
BEGIN 
SET @WORD=LEFT(@STR,1) 
--����Ǻ����ַ��o����ԭ�ַ� 
SET @PY=@PY+(CASE WHEN UNICODE(@WORD) BETWEEN 19968 AND 19968+20901 
THEN ( 
SELECT TOP 1 PY 
FROM 
( 
SELECT 'A' AS PY,N'�' AS WORD 
UNION ALL SELECT 'B',N'��' 
UNION ALL SELECT 'C',N'�e' 
UNION ALL SELECT 'D',N'�z' 
UNION ALL SELECT 'E',N'��' 
UNION ALL SELECT 'F',N'�v' 
UNION ALL SELECT 'G',N'�B' 
UNION ALL SELECT 'H',N'��' 
UNION ALL SELECT 'J',N'�h' 
UNION ALL SELECT 'K',N'�i' 
UNION ALL SELECT 'L',N'�w' 
UNION ALL SELECT 'M',N'��' 
UNION ALL SELECT 'N',N'��' 
UNION ALL SELECT 'O',N'�a' 
UNION ALL SELECT 'P',N'��' 
UNION ALL SELECT 'Q',N'��' 
UNION ALL SELECT 'R',N'�U' 
UNION ALL SELECT 'S',N'�R' 
UNION ALL SELECT 'T',N'�X' 
UNION ALL SELECT 'W',N'�F' 
UNION ALL SELECT 'X',N'�R' 
UNION ALL SELECT 'Y',N'�' 
UNION ALL SELECT 'Z',N'��' 
) T 
WHERE WORD>=@WORD COLLATE CHINESE_PRC_CS_AS_KS_WS 
ORDER BY PY ASC 
) 
ELSE @WORD 
END) 
SET @STR=RIGHT(@STR,LEN(@STR)-1) 
END 
RETURN @PY 
END
Go

-- ͨ�ò�ѯ

-- ��ѯ���л��ȡ�
create proc guest.showAllGallery
	as
	select GID as ���Ⱥ�, GNAME as ������, GLOCATION as �ص� from GALLERY;
go

-- ��ѯ����չ����
-- ʹ���������ӣ���ֹ�еĻ����Ѿ�ע��
create proc guest.showAllExb
	as
	select EXHIBITION.EID as չ����, ENAME as չ����, ESTARTDATE as ��ʼ����, EENDDATE as ��������, GNAME as �ٰ췽 
	from EXHIBITION left outer join GALLERY on EXHIBITION.GID = GALLERY.GID
go

-- ��ѯĳ�����ȿ�չ��չ����
-- Ϊ�˷�ֹ����ע��������ʹ�û������ֻ��߻��ȺŲ�ѯ
create proc guest.showGalleryExb
	@gid varchar(20) = NULL
	-- @gname varchar(30) = NULL
	as
	select EXHIBITION.EID as չ����, ENAME as չ����, ESTARTDATE as ��ʼ����, EENDDATE as ��������, GNAME as �ٰ췽 
	from EXHIBITION,GALLERY where EXHIBITION.GID = GALLERY.GID and EXHIBITION.GID = @gid;
go

-- ��ѯ���������ҡ�
create proc guest.showAllArtist
	as
	select ARTISTID as �����Һ�,ARTISTNAME as ����,ARTISTBP as ������,ARTISTSTYLE as ��Ʒ���,GNAME as ǩԼ���� 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID
go
��
-- ��ѯĳ������ǩԼ������������
create proc guest.showGalleryArtist
	@gid varchar(20)
	as
	select ARTISTID as �����Һ�,ARTISTNAME as ����,ARTISTBP as ������,ARTISTSTYLE as ��Ʒ���,GNAME as ǩԼ���� 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID where ARTIST.GID = @gid;
go

-- ��ѯĳ��չ����ص����������ҡ�
create proc guest.showExbArtist
	@eid varchar(10)
	as
	select ARTISTID as �����Һ�,ARTISTNAME as ����,ARTISTBP as ������,ARTISTSTYLE as ��Ʒ���,GNAME as ǩԼ���� 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID 
	where ARTISTID in (select distinct EID from EXB_ARTIST where EID = @eid);
go

-- ��ѯ������Ʒ��
create proc guest.showAllArtwk
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���Һ�,GID as ��������,EID as ����չ��
	from ARTWORK;
go

-- ��ѯĳ������������Ʒ
create proc guest.showGalleryArtwk
	@gid varchar(20)
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���ߺ�,GID as ��������,EID as ����չ��
	from ARTWORK
	where GID = @gid
go

-- ��ѯĳ��չ��������Ʒ
create proc guest.showExbArtwk
	@eid varchar(20)
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���ߺ�,GID as ��������,EID as ����չ��
	from ARTWORK
	where EID = @eid
go

-- ��ѯĳ��������������Ʒ
create proc guest.showArtistArtwk
	@artistid varchar(20)
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���ߺ�,GID as ��������,EID as ����չ��
	from ARTWORK
	where ARTISTID = @artistid
go

-- ��ѯĳ�����������Ʒ
create proc guest.showTypicalArtwk
	@type varchar(10)
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���ߺ�,GID as ��������,EID as ����չ��
	from ARTWORK
	where ARTTYPE = @type
go

-- ��ȷ������Ʒ(������Ʒ�Ż��߰�����Ʒ��)
create proc guest.exactFindArtwk
	@artid varchar(20),
	@name varchar(30)
	as
	select ARTID as ��Ʒ��,ARTTITLE as ��Ʒ��, ARTTYPE as ��Ʒ����,ARTYEAR as �������,ARTPRICE as �ο���,
	ARTSTATUS as ״̬,ARTISTID as ���ߺ�,GID as ��������,EID as ����չ��
	from ARTWORK
	where ARTID = @artid or ARTTITLE = @name;
go
