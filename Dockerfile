FROM python:3.11.7-slim
WORKDIR /app
COPY app/ /app
RUN apt-get update && apt-get install -y libpq-dev python3-dev build-essential
RUN pip install -r requirements.txt
EXPOSE 8000
# Run migrations and start the server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]