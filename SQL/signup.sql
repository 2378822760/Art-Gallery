-- 使用SQL命令管理登录账户
-- 语法格式如下:
-- sp_addlogin '登录账户名','登陆密码','默认数据库','默认语言'
-- 删除语法格式如下：
-- sp_droplogin '登录账户名'
-- 注册一个画廊管理员，一个艺术家，一个顾客
-- 他们的服务器角色都为public
use AG
go
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
exec sp_grantdbaccess 'Gallery'
exec sp_grantdbaccess 'Artist'
exec sp_grantdbaccess 'Customer'
go

-- 为将数据库用户和数据库角色映射
exec sp_addrolemember R_GALLERY, Gallery;
exec sp_addrolemember R_ARTIST, Artist;
exec sp_addrolemember R_CUSTOMER, Customer;
go
