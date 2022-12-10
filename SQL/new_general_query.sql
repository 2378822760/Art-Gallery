-- 查询所有画廊√
select GID as 画廊号, GNAME as 画廊名, GLOCATION as 地点 from GALLERY;

-- 查询所有展览√
select EXHIBITION.EID as 展览号, ENAME as 展览名, ESTARTDATE as 开始日期, EENDDATE as 结束日期, GNAME as 举办方 
from EXHIBITION,GALLERY where EXHIBITION.GID = GALLERY.GID;

-- 查询某个画廊开展的展览√
select EXHIBITION.EID as 展览号, ENAME as 展览名, ESTARTDATE as 开始日期, EENDDATE as 结束日期, GNAME as 举办方 
from EXHIBITION,GALLERY where EXHIBITION.GID = GALLERY.GID and EXHIBITION.GID = @gid;

-- 查询所有艺术家√
select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID

-- 查询某个画廊签约的所有艺术家√
select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID where ARTIST.GID = @gid;

-- 查询某个展览相关的所有艺术家√
select ARTISTID as 艺术家号,ARTISTNAME as 姓名,ARTISTBP as 出生地,ARTISTSTYLE as 作品风格,GNAME as 签约画廊 
from ARTIST left outer join GALLERY on ARTIST.GID = GALLERY.GID 
where ARTISTID in (select distinct EID from EXB_ARTIST where EID = @eid);

-- 查询所有作品√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作家号,GID as 所属画廊,EID as 所属展览
from ARTWORK;

-- 查询某个画廊所有作品√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
from ARTWORK
where GID = @gid

-- 查询某个展览所有作品√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
from ARTWORK
where EID = @eid

-- 查询某个艺术家所有作品√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
from ARTWORK
where ARTISTID = @artistid

-- 查询某个类别所有作品√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
from ARTWORK
where ARTTYPE = @type

-- 精确查找作品(按照作品号或者按照作品名)√
select ARTID as 作品号,ARTTITLE as 作品名, ARTTYPE as 作品类型,ARTYEAR as 创作年份,ARTPRICE as 参考价,
ARTSTATUS as 状态,ARTISTID as 作者号,GID as 所属画廊,EID as 所属展览
from ARTWORK
where ARTID = @artid or ARTTITLE = @name;
