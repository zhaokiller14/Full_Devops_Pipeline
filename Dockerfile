FROM python:3.13-slim
WORKDIR /app
RUN pip install --no-cache-dir uv
COPY pyproject.toml .
RUN uv sync --no-dev
COPY . .
EXPOSE 5000
CMD ["uv", "run", "flask", "run", "--host=0.0.0.0", "--port=5000"]
