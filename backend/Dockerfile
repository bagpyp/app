FROM python:3.13-slim

WORKDIR /app

COPY pyproject.toml poetry.lock ./
COPY src ./src

RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-root --no-interaction --no-ansi

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]