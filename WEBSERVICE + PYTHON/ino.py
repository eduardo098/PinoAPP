#import serial
import threading
import urllib
import urllib2
import json
from random import randint

def data():
    threading.Timer(2, data).start()
    #arduino = serial.Serial('COM4', 9600)
    #dataArduino = arduino.readline()
    #print (dataArduino)
    jsonArduino = {"humedad": randint(10, 50), "temperatura": randint(10, 20)}
    dataEncode = urllib.urlencode(jsonArduino)
    url = "http://localhost/WSArduino/raspino.php"
    request = urllib2.Request(url, dataEncode)
    print("Enviando Informacion")
    try:
        respuesta = urllib2.urlopen(request)
        dataRespuesta = respuesta.read()
        print(dataRespuesta)
        #arduino.write(bytes(dataRespuesta))
    except:
        print("Error enviando informacion")
data()
