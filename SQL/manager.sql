use AG
go
-- ARTIST
-- 艺术家注册
create proc Manager.loginArtist
	@name varchar(30),
	@bp varchar(40),
	@style varchar(10),
	@usrname char(11),
	@pwd char(20),
	@email char(30)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into ARTIST(ARTISTID,ARTISTNAME,ARTISTBP,ARTISTSTYLE)
	values(@id,@name,@bp,@style);
	insert into loginInfo(USRNAME,PASSWORD,ROLE,ID,EMAIL)
	values(@usrname,@pwd,'artist',@id,@email);
go

-- 使用艺术家ID删除艺术家
create proc Manager.logoffArtist
	@id varchar(20)
	as
	delete from ARTIST where ARTISTID = @id;
go

-- CUST_RECORD
-- 访问记录保留


-- CUSTOMER
-- 顾客注册
create proc Manager.loginCustomer
	@name varchar(30),
	@address varchar(40),
	@birth date,
	@phonenumber varchar(11),
	@usrname char(11),
	@pwd char(20),
	@email char(30)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into CUSTOMER(CID,CNAME,CADDRESS,CDOB,CPHONE)
	values(@id,@name,@address,@birth,@phonenumber);
	insert into loginInfo(USRNAME,PASSWORD,ROLE,ID,EMAIL)
	values(@usrname,@pwd,'customer',@id,@email);
go

-- 通过客户ID删除客户
create proc Manager.logoffCustomer
	@id varchar(20)
	as
	delete from CUSTOMER where CID = @id;
go

-- EXB_ARTIST
-- 权力下放

-- EXHIBITION
-- 展览信息保留

-- GALLERY
-- 画廊注册
create proc Manager.loginGallery
	@name varchar(30),
	@location varchar(40),
	@usrname char(11),
	@pwd char(20),
	@email char(30)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into GALLERY(GID,GNAME,GLOCATION)
	values(@id,@name,@location);
	insert into loginInfo(USRNAME,PASSWORD,ROLE,ID,EMAIL)
	values(@usrname,@pwd,'gallery',@id,@email);
go

-- 画廊离开系统，通过GID删除画廊
-- 修改GID字段为GALLERY的名字
create proc Manager.logoffGallery
	@id varchar(20)
	as
	declare @name varchar(30);
	select @name = GNAME from GALLERY where GID = @id;
	update EXHIBITION set GID = @name where GID = @id;
	delete from GALLERY where GID = @id;
go

-- 订单信息保留



--将汉字转为拼音首字母大写函数
Create FUNCTION guest.procGetPY(@str NVARCHAR(4000))
RETURNS NVARCHAR(4000) 
AS
BEGIN 
DECLARE @WORD NCHAR(1),@PY NVARCHAR(4000) 
SET @PY='' 
WHILE LEN(@STR)>0 
BEGIN 
SET @WORD=LEFT(@STR,1) 
--如果非汉字字符﹐返回原字符 
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
go
