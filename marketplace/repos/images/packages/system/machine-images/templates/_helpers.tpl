{{- /*
  Имена образов, которые публикует сама платформа (packages/system/vm-default-images).
  Пространство имён cozy-public общее и имя PVC там плоское, поэтому совпадение
  имени — это молчаливая перезапись чужого образа для всего кластера. Список
  сверяется при рендере, а не в рантайме.
*/ -}}
{{- define "machine-images.platformNames" -}}
ubuntu-20.04 ubuntu-22.04 ubuntu-24.04 rocky-8 rocky-9 rocky-10 almalinux-8 almalinux-9 almalinux-10 debian-12 debian-13 centos-stream-9 centos-stream-10 opensuse-leap-15.6 opensuse-leap-16.0 alpine-3.21
{{- end }}

{{- define "machine-images.labels" -}}
app.kubernetes.io/name: machine-images
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
