# Module 1: Generative Art
In this piece, every hour my program finds the number of positive COVID cases at Columbia in the past week. Once it finds this number, the LEDS will blink red that number of times and will display that number of Roarees with facemask gifs in a grid.

## About the codebase
The python script `web-api.py` scrapes https://covid19.columbia.edu/ to find the number of positive cases. It then uses the socket api to send that number to the Processing script `processing/processing.pde`. The python script acts as the server and the Processing script acts as the client, so `web-api.py` should be run first. The program uses NeoPixel Python library to control the LEDs ([reference](https://learn.adafruit.com/neopixels-on-raspberry-pi/python-usage)).

In `processing.pde` setup, it instantiates a Client object and loads Roaree images. These images were originally a gif, taken from [here](https://giphy.com/stickers/columbiauniversity-roaree-roar-lions-columbia-lion-gJodAHOgIT3C9a2Qg5). Processing does not support loading gifs, but you can render them as images. I started with Sequential example, under Animation, which showed how you could animate frames of a gif. I used ImageMagick's CLI convert [command](https://imagemagick.org/script/convert.php) to convert gif to 39 png files. The command I used is below. I was unable to run ImageMagick on the pi but it worked on my Windows laptop.

`convert roaree.gif roaree/roaree_%03d.png`

 In order to allow my system to update when Columbia posts new data, `web-api.py` will check the website every hour and will restart NeoPixels and trigger Processing to update with the number it received (does not have to be different).

## Starting on boot
Put `python3 /path/to/web-api.py` in `/etc/rc.local`

Put `processing-java --sketch=/path/to/processing/ --run` in `~/.config/lxsession/LXDE-pi/autostart`

Processing script cannot be run in `/etc/rc.local` because that is too early in boot process and it has not connected to the display yet. Even though `web-api.py` requires internet connction, which would also not be available when `/etc/rc.local` is called, it only sends internet requests when a client connects to its socket. In other words, `web-api.py` does not begin scraping Columbia's webpage until `processing.pde` starts and connects.

## About the hardware
I am using a Raspberry Pi Model 4B with an 8 LED NeoPixels module and a 1920x1080p Dell monitor. The NeoPixels were powered without level shifting:
- Pi 5V to NeoPixel 5V
- Pi GND to NeoPixel GND
- Pi GPIO18 to NeoPixel Din
