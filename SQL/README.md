# 测试流程
1.新建一个数据库\n
2.执行create_table中所有语句\n
3.执行create_role中所有语句\n
4.执行signup中所有语句\n
5.执行manager,gallery,artist,customer,general_query中所有创建存储过程的语句\n
6.随意测试\n
数据在Initdata文件中，按需插入。数据宝贵！\n
测试时可以不用考虑安全性问题用sa登录测试。\n
通用查询语句在general_query中，有new和old两个版本，new中的语句将数据字典转换为了对应的含义，但是old中有更加多样的查询方式。\n
每个角色的功能在其角色名文件下。\n
所有功能都已经用存储过程实现，测试相关功能只要调用存储过程就可以了！
