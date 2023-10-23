FROM python:3.9-slim-buster
RUN pip install flask
WORKDIR /app
COPY index.py .
EXPOSE 5000
ENTRYPOINT [ "python", "index.py" ]