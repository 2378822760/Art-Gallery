/*
	�����ߣ��������ܹ���ѯ���������ҵ���Ϣ����������Ʒ����Ϣ���ܹ���ѯĳ�����͡�
	������������Ʒ�����л��ȵ���Ϣ�����Ӧ��չ��չ������Ϣ���Լ���������Ʒ���˵���Ϣ
*/
-- һ����ѯ
declare @galleryid varchar;
declare @exhibitionid varchar;
declare @artistid varchar;
declare @cid varchar;
-- ��ѯ���л���
select * from GALLERY;
-- ��ѯ����չ��
select * from EXHIBITION;
select * from EXHIBITION where GID = @galleryid;
-- ��ѯ����������
select * from ARTIST;
select * from ARTIST where GID = @galleryid;
select * from ARTIST where EID = @exhibitionid;
-- ��ѯ������Ʒ
-- ������Ʒ��š���ݡ��۸��
-- �Լ����ֵ�������ϲ�ѯ
select * from ARTWORK order by ARTISTID ASC;
select * from ARTWORK order by ARTISTID DESC;
select * from ARTWORK order by ARTTYPE ASC;
select * from ARTWORK order by ARTTYPE DESC;
select * from ARTWORK order by ARTPRICE ASC;
select * from ARTWORK order by ARTPRICE DESC;

-- ��ѯĳ������������Ʒ
-- ������Ʒ��š���ݡ��۸��������ѯ��
-- �Լ����ֵ�������ϲ�ѯ
select * from ARTWORK where GID = @galleryid order by ARTISTID ASC;
select * from ARTWORK where GID = @galleryid order by ARTISTID DESC;
select * from ARTWORK where GID = @galleryid order by ARTTYPE ASC;
select * from ARTWORK where GID = @galleryid order by ARTTYPE DESC;
select * from ARTWORK where GID = @galleryid order by ARTPRICE ASC;
select * from ARTWORK where GID = @galleryid order by ARTPRICE DESC;

-- ��ѯĳ��չ��������Ʒ
-- ������Ʒ��š���ݡ��۸��������ѯ��
-- �Լ����ֵ�������ϲ�ѯ
select * from ARTWORK where EID = @exhibitionid order by ARTISTID ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTISTID DESC;
select * from ARTWORK where EID = @exhibitionid order by ARTTYPE ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTTYPE DESC;
select * from ARTWORK where EID = @exhibitionid order by ARTPRICE ASC;
select * from ARTWORK where EID = @exhibitionid order by ARTPRICE DESC;

-- ��ѯĳ��������������Ʒ
-- ������Ʒ��š���ݡ��۸��������ѯ��
-- �Լ����ֵ�������ϲ�ѯ
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTISTID ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTISTID DESC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTTYPE ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTTYPE DESC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTPRICE ASC;
select * from ARTWORK where ARTISTID in (select ARTISTID from EXB_ARTIST where ARTISTID = @artistid) order by ARTPRICE DESC;

-- ��ѯ��ʷ���׼�¼
select * from TRADE where CID = cid order by TRADEDATE ASC;
select * from TRADE where CID = cid order by TRADEDATE DESC;

select * from TRADE where CID = cid and TRADESTATUS = '���׽���' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '���׽���' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = '������' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '������' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = '���' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = '���' order by TRADEDATE DESC;
select * from TRADE where CID = cid and TRADESTATUS = 'ȡ��' order by TRADEDATE ASC;
select * from TRADE where CID = cid and TRADESTATUS = 'ȡ��' order by TRADEDATE DESC;

-- ��������ɾ���κ����ݵ�Ȩ��