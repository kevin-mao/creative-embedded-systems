import time
import vlc # video/music player
from picamera import PiCamera
from fer import FER
import matplotlib.pyplot as plt 

camera = PiCamera()

def music(source):
    media = vlc.MediaPlayer(source)
    media.play()
    while True:
        pass
    
# docs said to sleep at least 2 seconds before
time.sleep(2)
camera.resolution = (2592, 1944)
camera.capture('image.jpg')
img = plt.imread('image.jpg')
detector = FER(mtcnn=True)
print(detector.detect_emotions(img))
plt.imshow(img)

music("chopin-nocturne9no2.mp3")