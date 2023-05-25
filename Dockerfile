# Use a base image with Python and necessary dependencies
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies for psycopg2
RUN apt-get update \
    && apt-get install -y libpq-dev gcc
# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install project dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project files to the working directory
COPY . .

# Run any necessary database migrations
RUN python manage.py migrate

# Collect static files (if applicable)
RUN python manage.py collectstatic --no-input

# Expose the port your Django application will run on
EXPOSE 8000

# Specify the command to run your Django application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
