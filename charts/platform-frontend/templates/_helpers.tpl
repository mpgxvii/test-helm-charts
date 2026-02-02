{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "platform-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper image name (standalone, no common subchart).
*/}}
{{- define "platform-frontend.image" -}}
{{- $registry := default "ghcr.io" .Values.image.registry -}}
{{- $repository := .Values.image.repository -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
{{- $digest := .Values.image.digest | toString -}}
{{- if $digest }}
{{- printf "%s/%s@%s" $registry $repository $digest -}}
{{- else }}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "platform-frontend.imagePullSecrets" -}}
{{- with .Values.image.pullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited (DNS naming spec).
*/}}
{{- define "platform-frontend.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "platform-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "platform-frontend.labels" -}}
app.kubernetes.io/name: {{ include "platform-frontend.name" . }}
helm.sh/chart: {{ include "platform-frontend.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels (for deployment selector and service)
*/}}
{{- define "platform-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a secret name which can be overridden.
*/}}
{{- define "platform-frontend.secretname" -}}
{{- if .Values.secret.nameOverride -}}
{{- .Values.secret.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ include "platform-frontend.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Set value from existing secret if defined.
Arguments (dict): secret, key, context
*/}}
{{- define "platform-frontend.secret.value" -}}
{{- $secretObj := (lookup "v1" "Secret" .context.Release.Namespace .secret) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- get $secretData .key | b64dec }}
{{- end -}}
