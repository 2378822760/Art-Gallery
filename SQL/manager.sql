declare @artid varchar(10);
declare @artistid varchar(10);
declare @eid varchar(10);
declare @cid varchar(10);
declare @gid varchar(10);
-- ARTIST
-- ʹ����Ʒ��ɾ����Ʒ
delete from ARTWORK where ARTID = @artid;

-- ARTWORK
-- ʹ��������IDɾ��������
delete from ARTIST where ARTISTID = @artistid;

-- CUST_RECORD
-- ���ʼ�¼����


-- CUSTOMER
-- ͨ���ͻ�IDɾ���ͻ�
delete from CUSTOMER where CID = @cid;

-- EXB_ARTIST
-- Ȩ���·�

-- EXHIBITION
-- չ����Ϣ����

-- GALLERY
-- �����뿪ϵͳ��ͨ��GIDɾ������
delete from GALLERY where GID = @gid;

-- ������Ϣ����

