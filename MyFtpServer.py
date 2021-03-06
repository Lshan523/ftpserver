# -*- coding: UTF-8 -*-
import os
def handler_gbk():
    import pyftpdlib
    # 替换UTF-8 为GBK　解决中文名字乱码问题：ref:https://blog.csdn.net/weixin_39804265/article/details/122386381
    root = os.path.dirname(pyftpdlib.__file__)
    print(str(root))
    for file in ['filesystems.py', 'handlers.py']:
        path = os.path.join(root, file)
        with open(path, 'r+') as f:
            s = f.read()
            f.seek(0)
            f.truncate()
            f.write(s.replace("'utf8'", "'gbk'"))


def start_ftp_server():
    from pyftpdlib.authorizers import DummyAuthorizer
    from pyftpdlib.handlers import FTPHandler
    from pyftpdlib.servers import FTPServer
    #实例化虚拟用户，这是FTP验证首要条件
    authorizer = DummyAuthorizer()
    #添加用户权限和路径，括号内的参数是(用户名， 密码， 用户目录， 权限)
    authorizer.add_user(os.getenv("FTP_USER", "user"), os.getenv("FTP_PASSWORD", "123456"), os.getenv("FTP_USER_PATH", "/opt/ftp/user"), perm='elradfmwM')
    #添加匿名用户 只需要路径
    # authorizer.add_anonymous(os.getenv("FTP_ANONYMOUS_PATH", "/opt/ftp/anonymous"), perm='elradfmwM')
    authorizer.add_anonymous("/opt/ftp/anonymous", perm='elradfmwM')
    #初始化ftp句柄
    handler = FTPHandler
    #解决上传乱码
    # handler.decode = decode
    handler.authorizer = authorizer
    #设定一个客户端链接时的标语
    handler.banner = '你好吗？ 我已经注意你很久了！ 欢迎访问myftp.'
    #被动模式端口,用于文件下载
    handler.passive_ports = range(int(os.getenv("FTP_PASSIVE_PORT_FROM", 30000)), int(os.getenv("FTP_PASSIVE_PORT_TO", 30010)))
    # handler.passive_ports = range(30000, 30010)
    #监听ip 和 端口,因为linux里非root用户无法使用21端口，所以我使用了2121端口
    server = FTPServer(('0.0.0.0', int(os.getenv("FTP_PORT", 2121))), handler)
    #开始服务
    server.serve_forever()

if __name__ == '__main__':
    handler_gbk()
    start_ftp_server()
