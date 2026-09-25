#!/usr/bin/env python3
"""Перехватчик KubeVirt: подменяет описание машины на машину Вирта.

KubeVirt позволяет стороннему контейнеру переписать описание домена перед
запуском — это штатная точка расширения (`OnDefineDomain`), форк не нужен.
Сюда приходит описание, которое KubeVirt собрал для обычной виртуалки, а
уходит описание машины RISC5.

Что меняется:

  * тип домена — с `kvm` на `qemu`: аппаратного ускорения для чужой
    архитектуры не бывает;
  * архитектура и тип машины — на risc5/oberon;
  * путь к эмулятору — на наш, лежащий на общем томе;
  * убирается всё, что требует шины PCI: у машины Вирта нет ни PCI, ни USB,
    ни звука, и libvirt на них отвечает «No PCI buses available»;
  * убираются свойства уровня платформы — ACPI, APIC и прочее: их у машины
    тоже нет, и libvirt отвергает описание целиком
    («machine type 'oberon' does not support ACPI»);
  * число процессоров приводится к одному: у машины Вирта он один, и libvirt
    отвергает описание, где запрошено больше
    («Maximum CPUs greater than specified machine type limit 1»);
  * добавляются ПЗУ и образ диска — привычной микропрограммы у машины нет.

Запускается обёрткой sidecar-shim: она ищет исполняемый файл с именем
onDefineDomain и передаёт описание аргументами.
"""
import sys
import xml.etree.ElementTree as ET

# Пути внутри контейнера, куда общий том приносит эмулятор и образы.
# Он же монтируется в контейнер с libvirt через sharedComputePath.
EMULATOR = '/usr/local/bin/qemu-system-risc5'
PROM     = '/payload/prom.bin'
DISK     = '/payload/oberon.dsk'

QEMU_NS = 'http://libvirt.org/schemas/domain/qemu/1.0'


def arg(name):
    """Читает --name значение из аргументов, как их передаёт обёртка."""
    a = sys.argv
    for i, v in enumerate(a):
        if v == '--' + name and i + 1 < len(a):
            return a[i + 1]
        if v.startswith('--' + name + '='):
            return v.split('=', 1)[1]
    return None


def convert(domain_xml):
    ET.register_namespace('qemu', QEMU_NS)
    root = ET.fromstring(domain_xml)

    # ── Тип домена ────────────────────────────────────────────────────────
    #
    # KubeVirt объявляет домен как `kvm`, потому что рассчитывает на обычную
    # виртуалку с аппаратным ускорением. Наш эмулятор его не даёт и дать не
    # может: RISC5 — чужая архитектура, её команды переводятся на лету.
    # libvirt это проверяет и отвергает: «Emulator does not support virt type
    # kvm».
    root.set('type', 'qemu')

    # ── Архитектура и машина ──────────────────────────────────────────────
    os_el = root.find('os')
    type_el = os_el.find('type')
    type_el.set('arch', 'risc5')
    type_el.set('machine', 'oberon')

    # ⚠ Режим smbios убираем, а раздел sysinfo ОСТАВЛЯЕМ. Тонкость: из режима
    # libvirt выводит аргумент -smbios, которого наша цель не понимает
    # («Option not supported for this target»), а сам раздел sysinfo читает
    # virt-launcher уже после запуска и без него падает. Два требования тянут
    # в разные стороны, и развести их можно только так.
    for sm in os_el.findall('smbios'):
        os_el.remove(sm)

    # ── Свойства платформы ────────────────────────────────────────────────
    #
    # KubeVirt объявляет ACPI и APIC, рассчитывая на обычную машину. У Вирта
    # нет ни того, ни другого, и libvirt отвергает описание целиком:
    # «machine type 'oberon' does not support ACPI». Нашлось только на живом
    # кластере — в рукописном описании этих свойств просто не было.
    for f in root.findall('features'):
        root.remove(f)

    # Топология процессора и управление питанием — оттуда же.
    #
    # ⚠ sysinfo НЕ трогаем: его читает сам virt-launcher уже после запуска, и
    # без него он падает с «Domain sysinfo are not available». Убирать надо
    # ровно то, что отвергает libvirt, и ни строкой больше.
    for tag in ('cpu', 'clock', 'pm', 'cputune', 'numatune',
                'launchSecurity', 'iothreads'):
        for el in root.findall(tag):
            root.remove(el)

    # ── Число процессоров ─────────────────────────────────────────────────
    #
    # У машины Вирта процессор один, и больше быть не может. KubeVirt же
    # проставляет и текущее число, и предел для горячего добавления, а libvirt
    # сверяет их с возможностями машины и отвергает описание.
    for vcpu in root.findall('vcpu'):
        vcpu.text = '1'
        for a in ('current', 'placement'):
            vcpu.attrib.pop(a, None)
    for vcpus in root.findall('vcpus'):
        root.remove(vcpus)

    devices = root.find('devices')

    # ── Эмулятор ──────────────────────────────────────────────────────────
    emu = devices.find('emulator')
    if emu is None:
        emu = ET.SubElement(devices, 'emulator')
    emu.text = EMULATOR

    # ── Убрать всё, чему нужна шина PCI ───────────────────────────────────
    #
    # У машины Вирта её нет вовсе. Мало убрать сами устройства: KubeVirt
    # добавляет контроллеры, каналы и последовательные порты, которые libvirt
    # тоже привяжет к PCI.
    for tag in ('controller', 'video', 'memballoon', 'sound', 'channel',
                'rng', 'watchdog', 'redirdev', 'hostdev', 'input',
                'interface', 'disk', 'serial', 'console', 'graphics',
                'tpm', 'smartcard', 'filesystem'):
        for el in devices.findall(tag):
            devices.remove(el)

    # Взамен — явные заглушки там, где libvirt иначе подставит своё.
    ET.SubElement(devices, 'controller', {'type': 'usb', 'model': 'none'})
    ET.SubElement(devices, 'memballoon', {'model': 'none'})
    ET.SubElement(ET.SubElement(devices, 'video'), 'model', {'type': 'none'})

    # ── ПЗУ и диск ────────────────────────────────────────────────────────
    #
    # Через прямую передачу аргументов: у машины нет ни микропрограммы в
    # привычном смысле, ни контроллера диска, который libvirt умеет описывать.
    for el in root.findall('{%s}commandline' % QEMU_NS):
        root.remove(el)
    cl = ET.SubElement(root, '{%s}commandline' % QEMU_NS)
    for v in ('-bios', PROM,
              '-drive', f'if=none,id=sd0,file={DISK},format=raw'):
        ET.SubElement(cl, '{%s}arg' % QEMU_NS, {'value': v})

    return ET.tostring(root, encoding='unicode')


def main():
    domain_xml = arg('domain')
    if not domain_xml:
        sys.exit('перехватчику не передали описание домена')
    print(convert(domain_xml))


if __name__ == '__main__':
    main()
