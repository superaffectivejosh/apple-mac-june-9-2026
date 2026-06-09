# Use the official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install Python 3 along with pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the application files into the container
COPY app.py /app/

# (Optional) Install dependencies if you have a requirements.txt
# Install all requirements for Python app from Ubuntu 24.04
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages

# Command to run the Python script
CMD ["python3", "app.py"]
