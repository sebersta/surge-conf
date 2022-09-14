import sys
import requests

def convert(raw):
    speed=float(raw)
    units=['B/s','KB/s','MB/s','GB/s','TB/s','PB/s']
    unit=0

    while speed>=1000:
        speed=speed/1000
        unit+=1
    return str(round(speed, 2))+units[unit]

def main():
    URL = "http://192.168.1.8:5516/v1/traffic"
    headers = {'X-Key':'nocturne'}
    r = requests.get(url = URL, headers = headers)
    data = r.json()

    up = convert(data['interface']["en11"]['outCurrentSpeed'])
    down = convert(data['interface']["en11"]['inCurrentSpeed'])
    print("DOWNLOAD "+down)
    print("UPLOAD "+up)

if __name__=="__main__":
    main()