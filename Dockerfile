FROM python:3.9-alphine3.13
# Use alphine is lite of linux

LABEL maintainer="usef.com"

ENV PYTHONUNBUFFERED 1 
# see log python immetediately on screen


COPY ./requirements.txt  /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

COPY ./app /app
# ./app in my local  /app in container

WORKDIR /app

EXPOSE 8000
# Port 8000 for this app on container

ARG DEV=false
ENV DEV=${DEV}
RUN python -m venv /py && \
    # Create virtualenvirnment 
    /py/bin/pip install --upgrade pip && \
    # Update pip 
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
         /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # Install requiremnts
    rm -rf /tmp && \
    # Remove requirement in tmp
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
    # Create user and run with this user
    # for safer for attack 

ENV PATH="/py/bin:$PATH"
# Update python env in linux to /py/bin

USER django-user