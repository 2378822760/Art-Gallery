-- ���ȹ���Ա

-- �޸�����Ʒ�۸�
declare @newprice money,@artid varchar(10);
update ARTWORK set ARTPRICE = @newprice where ARTID = @artid;
go

-- ��������ǩԼ
declare @artistid varchar(10),@gid varchar(10);
update ARTIST set GID = @gid where ARTISTID = @artistid;
go

-- �������ҽ�Լ
create proc breakContrack
	@gid varchar(10),
	@artistid varchar(10)
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
declare @gid varchar(10);
select * from TRADE where ARTID in (select * from ARTWORK where GID = @gid)
go

-- �ú��������������ת��Ϊ��д��ÿ����������ĸ��д
-- ���� '�й�' -> 'ZG'
Create FUNCTION dbo.procGetPY(@str NVARCHAR(4000))
	RETURNS NVARCHAR(4000) 
-- WITH ENCRYPTION 
AS
	BEGIN 
		DECLARE @WORD NCHAR(1),@PY NVARCHAR(4000) 
		SET @PY='' 
		WHILE LEN(@STR)>0 
		BEGIN 
		SET @WORD=LEFT(@STR,1) 
		--����ǝh���ַ��o����ԭ�ַ� 
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
-- ��չ��
create proc holdExhibition
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
-- test
-- exec holdExhibition '2022-12-9','2023-1-5','��ө';
-- drop proc holdExhibition

-- ����Ҫ��ӽ�����չ������Ʒ��EID�޸�λ����չ����
-- for artworkid in idlist:
declare @eid varchar(10), @artid varchar(10);
update ARTWORK set EID = @eid where ARTID = @artid;
-- �޸�EXB_ARTIST
insert into EXB_ARTIST(EID,ARTISTID) select EID,ARTISTID from ARTWORK where EID = @eid;
go

-- ��չ��ɾ��ĳ����Ʒ
create proc rmvArtwkFromExb
	@artid varchar(10),
	@eid varchar(10)
	as
	declare @artistid varchar(10);
	select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
	update ARTWORK set EID = NULL where EID = @eid;
	if exists(select * from ARTWORK where ARTISTID = @artistid) begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
go

-- ����չ��
create proc endExhibition
	@gid varchar(10),
	@eid varchar(10)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL where EID = @eid;
go

-- ����ע��
create proc glogoff
	@gid varchar(10)
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