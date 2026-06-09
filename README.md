# TechGenius Website (Docker + Google Cloud Run)

This repo contains a static multi-page site (HTML/CSS/JS). The Docker setup uses **Nginx** to serve the static files.

## 1) Build the Docker image
From this folder:

```bash
docker build -t techgenius-web:latest .
```

## 2) Test the container locally

```bash
docker run --rm -p 8080:8080 techgenius-web:latest
```
Then open: http://localhost:8080

## 3) Deploy to Google Cloud Run

### Prerequisites
- Google Cloud project created
- `gcloud` installed and authenticated
- Docker configured locally
- A service account with permissions to push images and deploy Cloud Run

### Variables (edit as needed)
```bash
export PROJECT_ID="your-gcp-project-id"
export REGION="us-central1"           # choose your region
export REPO_NAME="techgenius-web"    # Artifact Registry repo
export SERVICE_NAME="techgenius"      # Cloud Run service name
export IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/techgenius-web"
```

### Create Artifact Registry repo (run once)
```bash
gcloud artifacts repositories create "${REPO_NAME}" \
  --repository-format=docker \
  --location="${REGION}" \
  --description="TechGenius Web images" || true
```

### Build + push
```bash
docker build -t "${IMAGE_URI}:latest" .
docker push "${IMAGE_URI}:latest"
```

### Deploy
Cloud Run will set the `PORT` env var automatically; our container listens on **8080**.

```bash
gcloud run deploy "${SERVICE_NAME}" \
  --image "${IMAGE_URI}:latest" \
  --region "${REGION}" \
  --allow-unauthenticated \
  --platform managed
```

After deployment, Cloud Run prints the URL.

## Notes
- The site is multi-page (separate `.html` files). Unknown routes will return **404**.
- Static assets under `assets/` are cached for 7 days by Nginx.

