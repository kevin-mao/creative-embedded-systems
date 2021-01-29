import time
import board
import neopixel
import socket 
import requests
from bs4 import BeautifulSoup

# Choose an open pin connected to the Data In of the NeoPixel strip, i.e. board.D18
# NeoPixels must be connected to D10, D12, D18 or D21 to work.
pixel_pin = board.D18

# The number of NeoPixels
num_pixels = 8

pixels = neopixel.NeoPixel(pixel_pin, num_pixels, brightness=0.2, auto_write=False)

def reset():
    pixels.fill((0, 0, 0))
    pixels.show()

def flash(loops):
    DARK_RED = (100,0,0)
    reset()
    for _ in range(loops):
        pixels.fill(DARK_RED)
        pixels.show()
        time.sleep(1)

        reset()
        time.sleep(1)


def main():
    HOST = ''                 # Symbolic name meaning all available interfaces
    PORT = 50007              # Arbitrary non-privileged port
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(1)

    print(f"Listening on {PORT}")
    conn, addr = s.accept()
    print('Connected by', addr)

    while True:
        # get covid data for columbia
        r = requests.get("https://covid19.columbia.edu/")
        if r.status_code == 200:
            soup = BeautifulSoup(r.content, 'html.parser')
            positive = int(soup.select(".field--name-field-cu-card-text h3")[1].text)
            print(f"New cases over past week: {positive}")

            # send today's data
            conn.send(bytes(str(positive), 'utf8'))

            # flash red for half a second for each new case today
            flash(positive)

            # sleep for an hour
            time.sleep(3600)

        # if request failed, try again in 0.5 second
        else:
            print("Failed. Trying again...")
            time.sleep(0.5)

    conn.close()

if __name__ == "__main__":
    main()
