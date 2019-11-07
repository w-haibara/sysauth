# -*- coding : UTF-8 -*-

import socket

server_ip = "127.0.1.1"
server_port = 2325
buf_size = 1024
listen_num = 5
send_msg = "hello from server"

server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_sock.bind((server_ip, server_port))
server_sock.listen(listen_num)

while True:
    client_sock,addr = server_sock.accept()
    print("[tcp_server.py] connected addr: {}".format(addr))
    data = client_sock.recv(buf_size)
    print("[tcp_server.py] received data: {}".format(data.decode(encoding='utf-8')))
    client_sock.send(send_msg.encode('utf-8'))
    client_sock.close()
