# Use official Python image
FROM python:3.11-slim
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Expose FastAPI default port
EXPOSE 8000

# Run FastAPI app with uvicorn
CMD ["uvicorn", "main:app", "--host", "192.168.1.7", "--port", "8000"]
