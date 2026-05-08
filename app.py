from flask import Flask, Response, request
from prometheus_client import Counter, Histogram, generate_latest
import time

app = Flask(__name__)

# Prometheus metrics
request_count = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)

request_duration = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency',
    ['method', 'endpoint']
)

# Middleware to track metrics
@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    if request.path not in ['/metrics', '/health']:
        duration = time.time() - request.start_time
        request_duration.labels(method=request.method, endpoint=request.path).observe(duration)
        request_count.labels(
            method=request.method,
            endpoint=request.path,
            status=response.status_code
        ).inc()
    return response


@app.route("/", methods=["GET"])
def hello():
    return {"status": "ok", "message": "Hello DevOps"}, 200


@app.route("/health", methods=["GET"])
def health():
    """Health check endpoint for Kubernetes probes"""
    return {"status": "healthy", "service": "tp4"}, 200


@app.route("/metrics", methods=["GET"])
def metrics():
    """Prometheus metrics endpoint"""
    return Response(generate_latest(), mimetype="text/plain; version=0.0.4")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
