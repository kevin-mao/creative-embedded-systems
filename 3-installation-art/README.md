# Module 3: Installaion Art

This project is a variation of the preivous module: 2-Interactive Art.
I made a game in which the player controls a triangle that is tasked with fitting into a world
full of squares and circles. If the player touches another shape or does not change shapes fast enough, the player
will be noticed and the game ends. The game will start over until user flips switch back.
The game uses two buttons, one switch, and one joystick, all of which I acquired
from the ESP32 kit. These hardware components were connected to the ESP32 Wrover module, which would use WiFi
to send UDP packets to my laptop, which read the messages and ran the game.

## WiFi Configuration

Both my laptop and ESP32 needed to be connected to the same network. During development, I would use my phone's hotspot.
Once the ESP32 is powered on, it will print its IP address to Serial monitor and wait for an initial UDP packet, which will be sent by the game 
to indicate that the game is starting and it requires sensor data. It's important to make sure you have the right IP address in
the game. This should only need to be done once.

## Hardware Configuration
Components
- JoyStick
- 2 Buttons
- 1 Switch
- ESP 32 Wrover
- 9V LiPo battery (3.7V 650 mAh)

Joystick was wired according to Freenove_Ultimate_Starter_Kit_for_ESP32 Chapter 14. I was having issues using analogRead on pins 12 and 13, 
so I swapped them to 32 and 36 after reading this [post](https://github.com/espressif/arduino-esp32/issues/102).
Buttons were wired with one end connected to an IO pin and one end to ground. 
The switch was wired similarly with middle pin connected to ground and an end pin connected to an IO pin.
ESP32 Wrover was mounted on a GPIO extension board and a breadboard.

## ESP32 Wrover Software
This code was written and flashed to ESP32 Wrover unit using Arduino IDE. The code is in `sketch_feb26a/`. 
The code connects to WiFi, waits for a UDP packet, and then sends sensor data to sender of the initial packet.

## Pi Software
Pi code (`game_of_life/`) was written in Processing. The code has 4 states: home screen, in-game, and two end-game screens 
(one for not conforming  and one for touching another shape). In first state, program will show a home screen 
and will switch to in-game state if switch is flipped. At any time, if switch is flipped back, game returns 
to home screen. If player loses game, then the appropriate end-game screen is shown. The bouncing circles and 
squares that randomly switch are defined in NPC class in `npc.pde`.

## Pictures and video
[Video](https://youtu.be/S6F7EWYBjR8) of demo

Hardware configuration
![Hardware](Hardware.jpg)
