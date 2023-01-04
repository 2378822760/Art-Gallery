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

-- 查询某个画廊签约的所有艺术家
create proc guest.showGalleryArtist
	@gid varchar(20)
	as
	select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID where ARTIST.GID = @gid;
go

-- 查询某个展览相关的所有艺术家√
create proc guest.showExbArtist
	@eid varchar(20)
	as
	select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
	from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID 
	where ARTISTID in (select distinct ARTISTID from EXB_ARTIST where EID = @eid);
go

-- 查询所有作品√
create proc guest.showAllArtwk
	as
	select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
	ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
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
