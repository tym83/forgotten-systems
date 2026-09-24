{{- define "langpack.labels" -}}
app.kubernetes.io/name: langpack
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
paleocomputing.io/language: {{ .Values.language | quote }}
{{- end }}

{{- define "langpack.selector" -}}
app.kubernetes.io/name: langpack
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- /* Одно описание контейнера на оба режима: расходиться им незачем. */ -}}
{{- define "langpack.container" -}}
name: runtime
image: {{ .Values.image | quote }}
{{- with .Values.command }}
command: {{ toJson . }}
{{- end }}
{{- with .Values.args }}
args: {{ toJson . }}
{{- end }}
workingDir: {{ .Values.workdir | quote }}
{{- if eq .Values.mode "service" }}
ports:
  - name: http
    containerPort: {{ .Values.port }}
{{- end }}
resources:
  requests:
    cpu: {{ .Values.resources.cpu | quote }}
    memory: {{ .Values.resources.memory | quote }}
  limits:
    cpu: {{ .Values.resources.cpu | quote }}
    memory: {{ .Values.resources.memory | quote }}
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
volumeMounts:
  - name: work
    mountPath: {{ .Values.workdir | quote }}
  - name: tmp
    mountPath: /tmp
{{- if .Values.program }}
  - name: src
    mountPath: {{ .Values.srcdir | quote }}
    readOnly: true
{{- end }}
{{- end }}

{{- define "langpack.volumes" -}}
- name: work
  emptyDir: {}
- name: tmp
  emptyDir: {}
{{- if .Values.program }}
- name: src
  configMap:
    name: {{ .Release.Name }}-program
{{- end }}
{{- end }}
