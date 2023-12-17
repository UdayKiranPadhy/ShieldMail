FROM python:3.11-alpine

WORKDIR /code

COPY . /code

RUN pip install --upgrade pip wheel setuptools pip-tools \
    && pip install poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-root


CMD ["uvicorn", "--reload", "--host", "0.0.0.0", "--port", "80", "src.api.app:app"]