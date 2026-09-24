{{- define "handbook.labels" -}}
app.kubernetes.io/name: handbook
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "handbook.style" -}}
body{font:16px/1.6 system-ui,sans-serif;max-width:46rem;margin:3rem auto;padding:0 1rem}
pre{white-space:pre-wrap;font:14px/1.5 ui-monospace,monospace}
a{color:#0645ad;text-decoration:none}a:hover{text-decoration:underline}
li{margin:.4rem 0}
{{- end }}

{{- define "handbook.indexHtml" -}}
<!doctype html><meta charset="utf-8"><title>{{ .Values.title | html }}</title>
<style>{{ include "handbook.style" . }}</style>
<h1>{{ .Values.title | html }}</h1>
<ol>
{{- range .Values.pages }}
<li><a href="{{ .name }}.html">{{ .title | html }}</a></li>
{{- end }}
</ol>
{{- end }}

{{- define "handbook.pageHtml" -}}
{{- $page := .page -}}
<!doctype html><meta charset="utf-8"><title>{{ $page.title | html }}</title>
<style>{{ include "handbook.style" .root }}</style>
<p><a href="index.html">&larr; оглавление</a></p>
<h1>{{ $page.title | html }}</h1>
<pre>{{ $page.body | html }}</pre>
{{- end }}
