#syntax=docker/dockerfile:1.4
FROM python:3-windowsservercore

WORKDIR /usr/src/app

COPY requirement.txt ./
RUN pip install --no-cache-dir -r requirement.txt

COPY . .

CMD ["python", "./prepare.py"]