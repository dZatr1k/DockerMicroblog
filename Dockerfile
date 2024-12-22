FROM python:3.11-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN apk add --no-cache --virtual .build-deps \
    gcc musl-dev libffi-dev postgresql-dev \
    && apk add --no-cache libpq

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

RUN apk del .build-deps && rm -rf /root/.cache

RUN chown -R appuser:appgroup /app
USER appuser

ENV FLASK_APP=microblog.py
ENV FLASK_ENV=production

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
