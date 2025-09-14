FROM python:3.11-slim
WORKDIR /app
COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ ./app
ENV PORT=5000
EXPOSE 5000
CMD ["gunicorn", "-w", "2", "-b", ":5000", "app:app"]