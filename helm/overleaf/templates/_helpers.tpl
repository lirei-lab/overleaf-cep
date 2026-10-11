{{/*
Expand the name of the chart.
*/}}
{{- define "overleaf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "overleaf.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "overleaf.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "overleaf.labels" -}}
helm.sh/chart: {{ include "overleaf.chart" . }}
{{ include "overleaf.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "overleaf.selectorLabels" -}}
app.kubernetes.io/name: {{ include "overleaf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
MongoDB Connection String Helper
Generates the connect string based on bitnami/mongodb dependency
If auth is disabled, it will just be standard replica set string
*/}}
{{- define "overleaf.mongodb.uri" -}}
{{- printf "mongodb://%s-mongodb-0.%s-mongodb-headless:27017,%s-mongodb-1.%s-mongodb-headless:27017,%s-mongodb-2.%s-mongodb-headless:27017/sharelatex?replicaSet=%s" .Release.Name .Release.Name .Release.Name .Release.Name .Release.Name .Release.Name .Values.mongodb.replicaSetName }}
{{- end }}

{{/*
Redis Connection Host Helper
Connects to the master service created by bitnami/redis
*/}}
{{- define "overleaf.redis.host" -}}
{{- printf "%s-redis-master" .Release.Name }}
{{- end }}
