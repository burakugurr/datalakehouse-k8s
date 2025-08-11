{{/*
Return the app name.
*/}}
{{- define "nessie.name" -}}
nessie
{{- end }}

{{/*
Return the full name.
*/}}
{{- define "nessie.fullname" -}}
{{ include "nessie.name" . }}-{{ .Release.Name }}
{{- end }}
