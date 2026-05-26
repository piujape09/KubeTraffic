{{/* Common labels */}}
{{- define "kubetraffic.labels" -}}
app.kubernetes.io/name: kubetraffic
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: nginx
{{- end -}}
