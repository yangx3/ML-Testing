import request

target_url = ""
image_path=''

file = {'media': open(image_path, 'rb')}
requests.post(target_url, files=file)