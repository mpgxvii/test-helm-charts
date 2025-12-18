{{- define "platform-backend.name" -}}
{{- default .Chart.Name .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-backend.fullname" -}}
{{- $name := default .Chart.Name .Values.global.nameOverride -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- /* Helper to compute a resource name for a specific service */ -}}
{{- define "platform-backend.serviceFullname" -}}
{{- printf "%s-%s" (include "platform-backend.fullname" .root) .serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "platform-backend.labels" -}}
app.kubernetes.io/name: {{ include "platform-backend.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/part-of: {{ include "platform-backend.name" .root }}
app.kubernetes.io/component: {{ .serviceName }}
helm.sh/chart: {{ include "platform-backend.chart" .root }}
{{- end -}}

{{- define "platform-backend.selectorLabels" -}}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/name: {{ include "platform-backend.serviceFullname" . }}
{{- end -}}

{{- define "platform-backend.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create -}}
{{- default (include "platform-backend.fullname" .) .Values.global.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.global.serviceAccount.name -}}
{{- end -}}
{{- end -}}

