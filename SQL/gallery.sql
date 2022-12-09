-- 画廊管理员

-- 修改艺术品价格
declare @newprice money,@artid varchar(10);
update ARTWORK set ARTPRICE = @newprice where ARTID = @artid;
go

-- 与艺术家签约
declare @artistid varchar(10),@gid varchar(10);
update ARTIST set GID = @gid where ARTISTID = @artistid;
go

-- 与艺术家解约
create proc breakContrack
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

-- 一件查询本画廊订单
declare @gid varchar(10);
select * from TRADE where ARTID in (select ARTID from ARTWORK where GID = @gid)
go

-- 该函数将输入的中文转换为大写的每个汉字首字母缩写
-- 例如 '中国' -> 'ZG'
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
		--如果非漢字字符﹐返回原字符 
		SET @PY=@PY+(CASE WHEN UNICODE(@WORD) BETWEEN 19968 AND 19968+20901 
		THEN ( 
		SELECT TOP 1 PY 
		FROM 
		( 
		SELECT 'A' AS PY,N'驁' AS WORD 
		UNION ALL SELECT 'B',N'簿' 
		UNION ALL SELECT 'C',N'錯' 
		UNION ALL SELECT 'D',N'鵽' 
		UNION ALL SELECT 'E',N'樲' 
		UNION ALL SELECT 'F',N'鰒' 
		UNION ALL SELECT 'G',N'腂' 
		UNION ALL SELECT 'H',N'夻' 
		UNION ALL SELECT 'J',N'攈' 
		UNION ALL SELECT 'K',N'穒' 
		UNION ALL SELECT 'L',N'鱳' 
		UNION ALL SELECT 'M',N'旀' 
		UNION ALL SELECT 'N',N'桛' 
		UNION ALL SELECT 'O',N'漚' 
		UNION ALL SELECT 'P',N'曝' 
		UNION ALL SELECT 'Q',N'囕' 
		UNION ALL SELECT 'R',N'鶸' 
		UNION ALL SELECT 'S',N'蜶' 
		UNION ALL SELECT 'T',N'籜' 
		UNION ALL SELECT 'W',N'鶩' 
		UNION ALL SELECT 'X',N'鑂' 
		UNION ALL SELECT 'Y',N'韻' 
		UNION ALL SELECT 'Z',N'做' 
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
-- 办展览
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
-- exec holdExhibition '2022-12-9','2023-1-5','流萤';
-- drop proc holdExhibition

-- 将需要添加进本次展览的作品的EID修改位本次展览号
-- for artworkid in idlist:
declare @eid varchar(10), @artid varchar(10);
update ARTWORK set EID = @eid where ARTID = @artid;
-- 修改EXB_ARTIST
insert into EXB_ARTIST(EID,ARTISTID) select EID,ARTISTID from ARTWORK where EID = @eid;
go

-- 从展览删除某件作品
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

-- 结束展览
create proc endExhibition
	@gid varchar(10),
	@eid varchar(10)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL where EID = @eid;
go

-- 画廊注销
create proc glogoff
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
