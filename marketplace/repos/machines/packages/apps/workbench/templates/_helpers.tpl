{{- define "workbench.labels" -}}
app.kubernetes.io/name: workbench
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- /* Ссылка на артефакт компонента этого же репозитория. */ -}}
{{- define "workbench.artifact" -}}
{{- printf "%s-%s" .root.Values.artifactPrefix .component -}}
{{- end }}
