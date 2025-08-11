{{- define "trino.name" -}}
trino
{{- end }}

{{- define "trino.fullname" -}}
{{ .Release.Name }}-{{ include "trino.name" . }}
{{- end }}
