--一键部署，但不载入初始数据
create database AG
go

--创建基本表
--画廊
use AG
CREATE TABLE GALLERY
(
    GID VARCHAR(20) PRIMARY KEY,
    GNAME VARCHAR(30),
    GLOCATION VARCHAR(40)
);

--顾客
CREATE TABLE CUSTOMER
(
    CID VARCHAR(20) PRIMARY KEY,
    CNAME VARCHAR(30),
    CADDRESS VARCHAR(40),
    CDOB DATE,
    CPHONE VARCHAR(11)
);

--艺术家
CREATE TABLE ARTIST
(
    ARTISTID VARCHAR(20) PRIMARY KEY,
    ARTISTNAME VARCHAR(30),
    ARTISTBP VARCHAR(40),
    ARTISTSTYLE VARCHAR(20),
    GID VARCHAR(20),
	FOREIGN KEY(GID) REFERENCES GALLERY(GID) ON DELETE SET NULL
);

--展览
CREATE TABLE EXHIBITION
(
    EID VARCHAR(20) PRIMARY KEY,
    ESTARTDATE DATE,
    ENAME VARCHAR(30),
    EENDDATE DATE,
    GID VARCHAR(20)
);

--艺术品
CREATE TABLE ARTWORK
(
    ARTID VARCHAR(20) PRIMARY KEY,
    ARTTITLE VARCHAR(20),
    ARTTYPE VARCHAR(10),
    ARTYEAR VARCHAR(4),
    ARTPRICE MONEY,
    ARTSTATUS VARCHAR(10) DEFAULT('正常'),
    ARTISTID VARCHAR(20),
    GID VARCHAR(20),
    EID VARCHAR(20),
    FOREIGN KEY(ARTISTID) REFERENCES ARTIST(ARTISTID) ON DELETE CASCADE,
    FOREIGN KEY(GID) REFERENCES GALLERY(GID) ON DELETE SET NULL,
    FOREIGN KEY(EID) REFERENCES EXHIBITION(EID),
    CHECK(ARTSTATUS IN ('正常','展示中','已出售')),--艺术品状态仅能取三者之一
    CHECK(ARTPRICE > 0)
);

--参展满意度调查
CREATE TABLE CUST_RECORD
(
    EID VARCHAR(20),
    CID VARCHAR(20),
    SATISFACTION SMALLINT,
    PRIMARY KEY(EID,CID),
    CHECK(SATISFACTION>0 AND SATISFACTION<=5)
);

--参展艺术家
CREATE TABLE EXB_ARTIST
(
    EID VARCHAR(20),
    ARTISTID VARCHAR(20),
    PRIMARY KEY(EID,ARTISTID),
    FOREIGN KEY(EID) REFERENCES EXHIBITION(EID),
    FOREIGN KEY(ARTISTID) REFERENCES ARTIST(ARTISTID) ON DELETE CASCADE
);

--交易记录
CREATE TABLE TRADE
(
    TRADEID VARCHAR(20) PRIMARY KEY,
	PRICE MONEY,
    CID VARCHAR(20),
	CNAME VARCHAR(30),
    ARTID VARCHAR(20),
	ARTNAME VARCHAR(30),
    TRADEDATE DATE,
    TRADESTATUS VARCHAR(10) DEFAULT('建立'),
    GID VARCHAR(20), --使画廊管理人员能够根据GID快速查询自己画廊交易信息
    CHECK(TRADESTATUS IN ('建立','运输中','已完成','取消'))
);
go

-- 创建数据库角色
use AG
go
CREATE ROLE R_MANAGER;
CREATE ROLE R_CUSTOMER;
CREATE ROLE R_ARTIST;
CREATE ROLE R_GALLERY;
go

-- 为系统管理员分配权限
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

-- 为角色顾客分配权限
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

-- 为艺术家分配权限
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

-- 为画廊管理员分配权限
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

-- 使用SQL命令管理登录账户
-- 语法格式如下:
-- sp_addlogin '登录账户名','登陆密码','默认数据库','默认语言'
-- 删除语法格式如下：
-- sp_droplogin '登录账户名'
-- 注册一个画廊管理员，一个艺术家，一个顾客
-- 他们的服务器角色都为public
use AG
go
exec sp_addlogin 'Manager','123','AG'
exec sp_addlogin 'Gallery','123','AG'
exec sp_addlogin 'Artist','123','AG'
exec sp_addlogin 'Customer','123','AG'
go

-- 创建和登录名对应的数据库用户
-- 语法格式如下：
-- sp_grantdbaccess '登陆用户名','数据库用户名'
-- 数据库用户名缺失默认未登录用户名
-- 删除语法如下:
-- sp_revokedbacces '数据库用户名'
exec sp_grantdbaccess 'Manager'
exec sp_grantdbaccess 'Gallery'
exec sp_grantdbaccess 'Artist'
exec sp_grantdbaccess 'Customer'
go

-- 为将数据库用户和数据库角色映射
exec sp_addrolemember R_MANAGER, Manager;
exec sp_addrolemember R_GALLERY, Gallery;
exec sp_addrolemember R_ARTIST, Artist;
exec sp_addrolemember R_CUSTOMER, Customer;
go

-- 艺术家的特权操作

-- 查询自己作品历史交易记录
create proc Artist.showOrder
	@artistid varchar(20)
	as
	select TRADEID 订单号,  PRICE 交易金额, CID 顾客号, CNAME 姓名, ARTID 作品号, ARTNAME 作品名, TRADEDATE 日期, TRADESTATUS 订单状态状态, GID 交易画廊号
	from TRADE 
	where ARTID in (select ARTID from ARTWORK where ARTISTID  = @artistid)
go

-- 更改自己的个人信息
create proc Artist.alterArtistInfo
	@id varchar(20),
	@name varchar(30),
	@bp varchar(40),
	@style varchar(10)
	as
	update ARTIST set ARTISTNAME = @name,ARTISTBP = @bp,
	ARTISTSTYLE = @style where ARTISTID = @id;
go

-- 下架自己的艺术品
create proc Artist.noSellArtwk
	@artid varchar(20),
	@artistid varchar(20)
	as
	update ARTWORK set GID = NULL where ARTID = @artid and ARTISTID = @artistid;
go

-- 解约画廊
create proc Artist.breakContrack
	@gid varchar(20),
	@artistid varchar(20)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '您当前有作品正在展览，不能解约，请待展览结束后进行解约!';
	end
	else begin
		update ARTIST set GID = NULL where ARTISTID = @artistid;
		update ARTWORK set GID = NULL 
		where ARTID in (select ARTID from ARTWORK where ARTISTID = @artistid);
		print '解约成功';
	end
go

-- 艺术家注销
-- 注销操作由系统管理员完成
create proc Artist.logoff
	@artistid varchar(20)
	as
	if exists(select * from EXB_ARTIST where ARTISTID = @artistid) begin
		print '您当前有作品正在展览，不能注销，请待展览结束后进行注销!';
	end
	-- else begin
		-- 级联删除作品
		-- delete from ARTIST where ARTISTID = @artistid;
		-- ARTIST表删除操作由系统管理员执行
	-- end
go

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

-- 画廊管理员

-- 添加艺术品
create proc Gallery.addArtwk
	@name varchar(30),
	@type varchar(10),
	@cyear varchar(4),
	@price money,
	@artistid varchar(20),
	@gid varchar(20) = NULL
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);--将名字转为拼音
	select @num = 1000 * RAND();--随机一个序号
	select @id += CONVERT(varchar(3),@num);--组成ID
	insert into ARTWORK(ARTID,ARTTITLE,ARTYEAR,ARTTYPE,ARTPRICE,ARTISTID,GID)
	values(@id,@name,@cyear,@type,@price,@artistid,@gid);
go

-- 修改艺术品信息√
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

-- 与艺术家签约√
create proc Gallery.makeContrack
	@artistid varchar(20),
	@gid varchar(20)
	as
	update ARTIST set GID = @gid where ARTISTID = @artistid;
	update ARTWORK set GID = @gid where ARTISTID = @artistid;
go

-- 与艺术家解约√
create proc Gallery.breakContrack
	@gid varchar(20),
	@artistid varchar(20)
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
	@gid varchar(20)
	as
	select TRADEID as 订单号, PRICE 交易金额, CID as 顾客号, CNAME 姓名, ARTID 作品号,
	ARTNAME 作品名, TRADEDATE 日期, TRADESTATUS 订单状态状态, GID 交易画廊号
	from TRADE 
	where GID  = @gid;
go

-- 办展览√
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

-- 将需要添加进本次展览的作品的EID修改位本次展览号
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

-- 从展览删除某件作品√
create proc Gallery.rmvArtwkFromExb
	@artid varchar(20),
	@eid varchar(20)
	as
	declare @artistid varchar(20);
	select @artistid = ARTISTID from ARTWORK where ARTID = @artid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
	if exists(select * from ARTWORK where ARTISTID = @artistid) begin
		delete from EXB_ARTIST where ARTISTID = @artistid;
	end
go

-- 结束展览√
create proc Gallery.endExhibition
	@gid varchar(20),
	@eid varchar(20)
	as
	delete from EXB_ARTIST where EID = @eid;
	update ARTWORK set EID = NULL,ARTSTATUS = '正常' where EID = @eid;
go

-- 画廊注销√
create proc Gallery.logoff
	@gid varchar(20)
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

-- 修改订单状态
create proc Gallery.alterOrderStatus
	@tid varchar(20),
	@status char(6)
	as
	declare @aid varchar(20);
	select @aid = ARTID from TRADE where TRADEID = @tid;
	if(@status = '建立') begin
		update ARTWORK set ARTSTATUS = '已出售' where ARTID = @aid; end
	else if(@status = '取消') begin
		update ARTWORK set ARTSTATUS = '正常' where ARTID = @aid; end
	update TRADE set TRADESTATUS = @status where TRADEID = @tid;
go

use AG
go
-- ARTIST
-- 艺术家注册
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
	@phonenumber varchar(11)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into CUSTOMER(CID,CNAME,CADDRESS,CDOB,CPHONE)
	values(@id,@name,@address,@birth,@phonenumber)
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
	@location varchar(40)
	as
	declare @id varchar(20), @num decimal(3,0);
	select @id = guest.procGetPY(@name);
	select @num = 1000 * RAND();
	select @id += CONVERT(varchar(3),@num);
	insert into GALLERY(GID,GNAME,GLOCATION)
	values(@id,@name,@location)
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
Go

-- 通用查询

-- 查询所有画廊√
create proc guest.showAllGallery
	as
	select GID as 画廊号, GNAME as 画廊名, GLOCATION as 地点 from GALLERY;
go

-- 查询所有展览√
-- 使用左外连接，防止有的画廊已经注销
create proc guest.showAllExb
	as
	select EXHIBITION.EID as 展览号, ENAME as 展览名, ESTARTDATE as 开始日期, EENDDATE as 结束日期, GNAME as 举办方 
	from EXHIBITION left outer join GALLERY on EXHIBITION.GID = GALLERY.GID
go

-- 查询某个画廊开展的展览√
-- 为了防止画廊注销，可以使用画廊名字或者画廊号查询
create proc guest.showGalleryExb
	@gid varchar(20) = NULL
	-- @gname varchar(30) = NULL
	as
	select EXHIBITION.EID as 展览号, ENAME as 展览名, ESTARTDATE as 开始日期, EENDDATE as 结束日期, GNAME as 举办方 
	from EXHIBITION,GALLERY where EXHIBITION.GID = GALLERY.GID and EXHIBITION.GID = @gid;
go

-- 查询所有艺术家√
create proc guest.showAllArtist
	as
	select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID
go
√
-- 查询某个画廊签约的所有艺术家
create proc guest.showGalleryArtist
	@gid varchar(20)
	as
	select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID where ARTIST.GID = @gid;
go

-- 查询某个展览相关的所有艺术家√
create proc guest.showExbArtist
	@eid varchar(10)
	as
	select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID 
	where ARTISTID in (select distinct EID from EXB_ARTIST where EID = @eid);
go

-- 查询所有作品√
create proc guest.showAllArtwk
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作家号,GID as 所属画廊,EID as 所属展览
	from ARTWORK;
go

-- 查询某个画廊所有作品
create proc guest.showGalleryArtwk
	@gid varchar(20)
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
	from ARTWORK
	where GID = @gid
go

-- 查询某个展览所有作品
create proc guest.showExbArtwk
	@eid varchar(20)
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
	from ARTWORK
	where EID = @eid
go

-- 查询某个艺术家所有作品
create proc guest.showArtistArtwk
	@artistid varchar(20)
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
	from ARTWORK
	where ARTISTID = @artistid
go

-- 查询某个类别所有作品
create proc guest.showTypicalArtwk
	@type varchar(10)
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
	from ARTWORK
	where ARTTYPE = @type
go

-- 精确查找作品(按照作品号或者按照作品名)
create proc guest.exactFindArtwk
	@artid varchar(20),
	@name varchar(30)
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
	from ARTWORK
	where ARTID = @artid or ARTTITLE = @name;
go
