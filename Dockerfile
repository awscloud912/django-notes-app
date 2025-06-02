FROM python:3.9

# Set working directory
WORKDIR /app/backend

# Copy requirements file first to leverage Docker cache
COPY requirements.txt /app/backend/

# Update and install dependencies needed for mysqlclient and building packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y gcc default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

# Copy entire project files after installing dependencies (better caching)
COPY . /app/backend

# Expose port 8000
EXPOSE 8000

# Optional: Run migrations at container startup (uncomment if needed)
# CMD python manage.py migrate && python manage.py runserver 0.0.0.0:8000

# Run the Django development server by default
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
