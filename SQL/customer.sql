/*
	消费者：消费者能够查询所有艺术家的信息，所有艺术品的信息，能够查询某种类型、
	风格的所有艺术品，所有画廊的信息及其对应开展的展览的信息和自己购买艺术品的账单信息
*/
-- 一、查询
declare @galleryid varchar;
declare @exhibitionid varchar;
declare @artistid varchar;
declare @cid varchar;
-- 查询所有画廊
select * from GALLERY;
-- 查询所有展览
select * from EXHIBITION;
select * from EXHIBITION where GID = @galleryid;
-- 查询所有艺术家
select * from ARTIST;
select * from ARTIST where GID = @galleryid;
select * from ARTIST where EID = @exhibitionid;
-- 查询所有作品
-- 按照作品序号、年份、价格√
-- 以及三种的排列组合查询
select * from ARTWORK order by ARTISTID ASC;
select * from ARTWORK order by ARTISTID DESC;
select * from ARTWORK order by ARTTYPE ASC;
select * from ARTWORK order by ARTTYPE DESC;
select * from ARTWORK order by ARTPRICE ASC;
select * from ARTWORK order by ARTPRICE DESC;

-- 查询某个画廊所有作品
-- 按照作品序号、年份、价格升序降序查询√
-- 以及三种的排列组合查询
select * from ARTWORK where GID = @galleryid order by ARTISTID ASC;
select * from ARTWORK where GID = @galleryid order by ARTISTID DESC;
select * from ARTWORK where GID = @galleryid order by ARTTYPE ASC;
select * from ARTWORK where GID = @galleryid order by ARTTYPE DESC;
select * from ARTWORK where GID = @galleryid order by ARTPRICE ASC;
select * from ARTWORK where GID = @galleryid order by ARTPRICE DESC;

-- 查询某个展览所有作品
-- 按照作品序号、年份、价格升序降序查询√
-- 以及三种的排列组合查询
select * from ARTWORK where EID = @exhibitionid order by ARTISTID ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTISTID DESC;
select * from ARTWORK where EID = @exhibitionid order by ARTTYPE ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTTYPE DESC;
select * from ARTWORK where EID = @exhibitionid order by ARTPRICE ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTPRICE DESC;

-- 查询某个艺术家所有作品
-- 按照作品序号、年份、价格升序降序查询√
-- 以及三种的排列组合查询
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTISTID ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTISTID DESC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTTYPE ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTTYPE DESC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTPRICE ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTPRICE DESC;

-- 查询历史交易记录
select * from TRADE where CID = cid order by TRADEDATE ASC;
select * from TRADE where CID = cid order by TRADEDATE DESC;

select * from TRADE where CID = cid and TRADESTATUS = '交易建立' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '交易建立' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = '运输中' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '运输中' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = '完成' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '完成' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = '取消' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '取消' order by TRADEDATE DESC;

-- 消费者无删除任何数据的权限