# platform-frontend

Helm chart for the RADAR-base Researcher Portal (platform-frontend), a Next.js application for researchers to manage studies, participants, protocols, and data dashboards.

**Homepage:** <https://radar-base.org>

## Prerequisites

- Kubernetes 1.19+
- Helm 3+

## Installation

```bash
helm install platform-frontend ./chart/platform-frontend --namespace <namespace> --create-namespace
```

With custom values:

```bash
helm install platform-frontend ./chart/platform-frontend -f my-values.yaml --namespace <namespace>
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| server_name | string | `"localhost"` | Hostname for the Researcher Portal |
| replicaCount | int | `1` | Number of replicas |
| image.registry | string | `"ghcr.io"` | Image registry |
| image.repository | string | `"radar-base/platform-frontend"` | Image repository |
| image.tag | string | (chart appVersion) | Image tag |
| nameOverride | string | `""` | Partial override for fullname |
| fullnameOverride | string | `""` | Full override for release name |
| basePath | string | `"platform"` | Base path (must match Next.js basePath) |
| api.publicUrl | string | (derived) | Public API URL (NEXT_PUBLIC_API_URL) |
| api.backendBaseUrl | string | `""` | Server-side API URL override |
| backendApiBaseUrl | string | `""` | Backend API base URL (BACKEND_API_BASE_URL) |
| managementPortalUrl | string | `"http://management-portal:8080/managementportal"` | Management Portal URL |
| auth.* | object | (see values.yaml) | OAuth / Hydra URLs and cookie prefix |
| oauth.* | object | (see values.yaml) | OAuth client id, secret, redirect, scopes |
| secret.enabled | bool | `true` | Create secret for cookie/CSRF |
| ingress.enabled | bool | `true` | Create Ingress |
| ingress.path | string | `"/platform(/\|$)(.*)"` | Ingress path |
| livenessProbe.enabled | bool | `true` | Enable liveness probe |
| readinessProbe.enabled | bool | `true` | Enable readiness probe |
| startupProbe.enabled | bool | `true` | Enable startup probe |

### Health checks

Probes default to `GET /<basePath>/api/health`. If your app does not expose this route, either:

- Add a simple API route (e.g. `src/app/platform/api/health/route.ts`) that returns 200, or
- Override probes: set `livenessProbe.enabled`, `readinessProbe.enabled`, `startupProbe.enabled` to `false`, or set `customLivenessProbe` / `customReadinessProbe` to use a path that exists (e.g. `GET /platform`).

### OAuth / backend

Set `auth.authorizationUrl`, `auth.tokenUrl`, `auth.userinfoUrl`, and `oauth.clientId` / `oauth.clientSecret` / `oauth.redirectUri` to match your RADAR-base Hydra and Management Portal setup. Set `backendApiBaseUrl` or `api.backendBaseUrl` if the server-side API base URL differs from the public URL.

## Building the image

From the repository root:

```bash
docker build -t ghcr.io/radar-base/platform-frontend:<tag> .
```

## Uninstall

```bash
helm uninstall platform-frontend --namespace <namespace>
```
