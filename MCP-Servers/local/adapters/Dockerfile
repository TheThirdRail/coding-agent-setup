FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN pip install --no-cache-dir mcp requests docker

WORKDIR /opt/mcp-local-adapters

COPY MCP-Servers/adapters/mcp_adapter_server.py /opt/mcp-local-adapters/mcp_adapter_server.py

ENTRYPOINT ["python", "/opt/mcp-local-adapters/mcp_adapter_server.py"]
