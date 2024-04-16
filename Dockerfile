# Use an official Python runtime as the base image
FROM python:3.9

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Set the working directory in the container
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project into the container
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port on which the Django app will run
EXPOSE 8000

# Run the Gunicorn server
CMD ["gunicorn", "--bind", "127.0.0.1:8000", "MR_Mapping_API.wsgi"]
