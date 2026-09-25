{{- define "oberon-vm.labels" -}}
app.kubernetes.io/name: oberon-vm
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "oberon-vm.fullname" -}}
oberon-vm-{{ .Release.Name }}
{{- end }}
