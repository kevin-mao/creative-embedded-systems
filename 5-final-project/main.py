from picamera import PiCamera
from google.cloud import vision
import io
import time
import vlc 
import random
import os

ANGRY = 'angry'
HAPPY = 'happy'
SURPRISED = 'surprised'
SAD = 'sad'
NEUTRAL = 'neutral'

def play_music(emotion):
    song = random.choice(os.listdir(os.getcwd() + f"/music/{emotion}"))
    print(f"Playing song: {song}")

    media = vlc.MediaPlayer(f"./music/{emotion}/{song}")
    media.play()
    while True:
        pass

def take_picture(path):
    camera = PiCamera()

    # docs said to sleep at least 2 seconds before
    time.sleep(2)
    camera.resolution = (2592, 1944) # max resolution
    camera.capture(path)

def detect_faces(path):
    """Detects faces in an image."""
    client = vision.ImageAnnotatorClient()

    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)

    response = client.face_detection(image=image)
    if response.error.message:
        raise Exception(
        '{}\nFor more info on error messages, check: '
        'https://cloud.google.com/apis/design/errors'.format(
            response.error.message))

    face = response.face_annotations[0]
    emotions = {
        ANGRY: face.anger_likelihood,
        HAPPY: face.joy_likelihood,
        SURPRISED: face.surprise_likelihood,
        SAD: face.sorrow_likelihood
    }
    print(emotions)
    if sum(emotions.values()) == 4:
        res = NEUTRAL
    else:
        res = max(emotions, key=emotions.get)
    print(f"You're looking {res}")

    return res

def main():
    path = 'images/face.jpg'
    take_picture(path)
    emotion = detect_faces(path)
    play_music(emotion)


if __name__ == "__main__":
    main()

