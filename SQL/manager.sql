declare @artid varchar(10);
declare @artistid varchar(10);
declare @eid varchar(10);
declare @cid varchar(10);
declare @gid varchar(10);
-- ARTIST
-- 使用作品号删除作品
delete from ARTWORK where ARTID = @artid;

-- ARTWORK
-- 使用艺术家ID删除艺术家
delete from ARTIST where ARTISTID = @artistid;

-- CUST_RECORD
-- 访问记录保留


-- CUSTOMER
-- 通过客户ID删除客户
delete from CUSTOMER where CID = @cid;

-- EXB_ARTIST
-- 权力下放

-- EXHIBITION
-- 展览信息保留

-- GALLERY
-- 画廊离开系统，通过GID删除画廊
delete from GALLERY where GID = @gid;

-- 订单信息保留

