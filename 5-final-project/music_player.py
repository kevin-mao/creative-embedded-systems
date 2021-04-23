import time
import vlc # video/music player
# from picamera import PiCamera
from keras.models import load_model
import numpy as np
import face_recognition
import cv2
from PIL import Image

# camera = PiCamera()
emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Neutral', 'Sad', 'Surprise']

def music(source):
    media = vlc.MediaPlayer(source)
    media.play()
    while True:
        pass
    
# docs said to sleep at least 2 seconds before
# time.sleep(2)
# camera.resolution = (2592, 1944)
# camera.capture('image.jpg')

# music("chopin-nocturne9no2.mp3")
image = face_recognition.load_image_file("./sad.jpg")
face_locations = face_recognition.face_locations(image)
top, right, bottom, left = face_locations[0]
face_image = image[top:bottom, left:right]

face_image = cv2.resize(face_image, (48,48))
face_image = cv2.cvtColor(face_image, cv2.COLOR_BGR2GRAY)
im = Image.fromarray(face_image)
im.save('test.png')
face_image = np.reshape(face_image, [1, face_image.shape[0], face_image.shape[1], 1])

model = load_model("model_v6_23.hdf5")
predicted_class = np.argmax(model.predict(face_image))
print(emotions[predicted_class])