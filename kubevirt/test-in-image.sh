#!/bin/sh
# Запуск Оберона внутри образа virt-launcher — через тот же libvirt,
# который будет работать в кластере.
set -e
mkdir -p /var/run/libvirt /var/lib/libvirt /var/log/libvirt
virtlogd -d 2>/dev/null; sleep 2
virtqemud -d 2>/dev/null; sleep 4

cat > /tmp/d.xml <<'XML'
<domain type="qemu" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0">
  <name>oberon</name>
  <memory unit="MiB">16</memory>
  <os><type arch="risc5" machine="oberon">hvm</type></os>
  <devices>
    <emulator>/usr/local/bin/qemu-system-risc5</emulator>
    <controller type="usb" model="none"/>
    <memballoon model="none"/>
    <video><model type="none"/></video>
  </devices>
  <qemu:commandline>
    <qemu:arg value="-bios"/>
    <qemu:arg value="/payload/prom.bin"/>
    <qemu:arg value="-drive"/>
    <qemu:arg value="if=none,id=sd0,file=/payload/oberon.dsk,format=raw"/>
  </qemu:commandline>
</domain>
XML

virsh -c qemu:///system define /tmp/d.xml
virsh -c qemu:///system start oberon
sleep 18
echo "--- состояние ---"
virsh -c qemu:///system list
echo "--- снимок памяти экрана ---"
virsh -c qemu:///system qemu-monitor-command oberon \
  '{"execute":"pmemsave","arguments":{"val":950016,"size":98304,"filename":"/tmp/img_fb.bin"}}'
# Снимок кладётся во временный каталог образа: туда libvirt писать вправе,
# а наружу выносим отдельно.
cp /tmp/img_fb.bin /out/img_fb.bin 2>/dev/null || cat /tmp/img_fb.bin > /out/img_fb.bin
ls -la /out/img_fb.bin | awk '{print "  вынесено:", $5, "байт"}'
