#!/usr/bin/env python
# -*- coding: utf-8 -*-
#This code was written with reference to this page: http://rabbitfoot141.hatenablog.com/entry/2018/01/22/111550

import socket

server_ip= "127.0.1.1"
server_port = 2325
buf_size = 1024
message = "hello from client"

client_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_sock.connect((server_ip, server_port))
client_sock.send(message.encode('utf-8'))
data = client_sock.recv(buf_size)
print("[tcp_client.py] msg from server: {}".format(data.decode(encoding='utf-8')))

