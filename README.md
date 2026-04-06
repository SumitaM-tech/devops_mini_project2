# DevOps Mini Project

> CI/CD Pipeline · Docker · GitHub Actions · Nginx

[![CI/CD](https://github.com/SumitaM-tech/devops_mini_project/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/SumitaM-tech/devops_mini_project/actions/workflows/ci-cd.yml)

## Quick Start

```bash
git clone https://github.com/SumitaM-tech/devops_mini_project.git
cd devops_mini_project
cd app && npm install && cd ..
docker compose up --build
# Open http://localhost
```

## Pipeline

```
Push → Test → Docker Build → Push ghcr.io → SSH Deploy → Health Check
```

## Required GitHub Secrets

| Secret | Value |
|--------|-------|
| `SERVER_HOST` | Your server IP |
| `SERVER_USER` | SSH user (e.g. ubuntu) |
| `SSH_PRIVATE_KEY` | Private key content |

## Endpoints

| URL | Description |
|-----|-------------|
| `GET /` | Dashboard UI |
| `GET /health` | Health check JSON |
| `GET /api/info` | App info & stats |
