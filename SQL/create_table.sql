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

--登录信息表
USE [AG]
GO

/****** Object:  Table [dbo].[loginInfo]    Script Date: 2023/1/15 16:42:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[loginInfo](
	[USRNAME] [char](11) NOT NULL,
	[PASSWORD] [char](20) NOT NULL,
	[ROLE] [char](10) NOT NULL,
	[ID] [char](10) NOT NULL,
	[EMAIL] [char](30) NOT NULL,
 CONSTRAINT [PK__loginInf__8D4D4051FC9B8512] PRIMARY KEY CLUSTERED 
(
	[USRNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

