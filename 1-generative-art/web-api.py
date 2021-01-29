# Echo server program
import socket
import time
import requests

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
print(f"Listening on {PORT}")

conn, addr = s.accept()
print('Connected by', addr)
while True:
    # get covid data for NY
    r = requests.get("https://api.covidtracking.com/v1/states/ny/current.json")
    if r.status_code == 200:
        data = r.json()
        increase = data['positiveIncrease']
        print(f"New cases on {data['date']}: {increase}")

        # send today's data
        conn.send(bytes(str(increase), 'utf8'))

        # send again in 12 hours
        time.sleep(4)

    # if request failed, try again in 0.5 second
    else:
        print("Failed. Trying again...")
        time.sleep(0.5)

conn.close()
