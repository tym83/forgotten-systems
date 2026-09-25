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
  * добавляются ПЗУ и образ диска — привычной микропрограммы у машины нет.

Запускается обёрткой sidecar-shim: она ищет исполняемый файл с именем
onDefineDomain и передаёт описание аргументами.
"""
import sys
import xml.etree.ElementTree as ET

# Пути внутри контейнера, куда общий том приносит эмулятор и образы.
# Он же монтируется в контейнер с libvirt через sharedComputePath.
EMULATOR = '/var/run/risc5/qemu-system-risc5'
PROM     = '/var/run/risc5/prom.bin'
DISK     = '/var/run/risc5/oberon.dsk'

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
