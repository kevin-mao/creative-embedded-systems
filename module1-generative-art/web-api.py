# Echo server program
import socket
import time

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
while True:
    conn.send(b"test\n")
    time.sleep(1)
conn.close()
# optionally put a loop here so that you start 
# listening again after the connection closes
