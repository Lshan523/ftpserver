# -*- coding: UTF-8 -*-
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
import os
#实例化虚拟用户，这是FTP验证首要条件
authorizer = DummyAuthorizer()
#添加用户权限和路径，括号内的参数是(用户名， 密码， 用户目录， 权限)
authorizer.add_user(os.getenv("FTP_USER", "user"), os.getenv("FTP_PASSWORD", "123456"), os.getenv("FTP_USER_PATH", "/opt/ftp/user"), perm='elradfmwM')
#添加匿名用户 只需要路径
# authorizer.add_anonymous(os.getenv("FTP_ANONYMOUS_PATH", "/opt/ftp/anonymous"), perm='elradfmwM')
authorizer.add_anonymous("/opt/ftp/anonymous", perm='elradfmwM')
#初始化ftp句柄
handler = FTPHandler
handler.authorizer = authorizer
#设定一个客户端链接时的标语
handler.banner = '你好吗？ 我已经注意你很久了！ 欢迎访问myftp.'
handler.passive_ports = range(30000, 30010)
#监听ip 和 端口,因为linux里非root用户无法使用21端口，所以我使用了2121端口
server = FTPServer(('0.0.0.0', 2121), handler)
#开始服务
server.serve_forever()
