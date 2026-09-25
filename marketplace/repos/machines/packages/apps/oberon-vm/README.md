# Oberon VM — Wirth's RISC5 as a virtual machine

A whole architecture, plugged into the cluster from outside. The machine that
starts here is not an emulator pretending to be Oberon hardware: it is a QEMU
target built from Wirth's own circuit description, verified against it
instruction by instruction.

## What you get

Project Oberon of 1986, booting from its own disk image: the log, the tool
window, the editor, the compiler. A complete system — processor, compiler,
operating system, windows — in about six thousand lines.

## Three mouse buttons

Oberon needs all three, and a laptop has none of the middle one. The machine
translates modifier chords, and says so on its own screen for the first half
minute:

| hold | and click | you get |
|---|---|---|
| Alt | left | middle button — **runs commands** |
| Ctrl | left | right button |
| Shift | left | both at once — the *interclick* |

The interclick is how the second corner of a rectangle is placed. Without it
part of the system is out of reach.

## What the cluster must provide

Two things, set once by whoever runs the cluster — a tenant cannot set them:

1. **The `Sidecar` feature gate** in the KubeVirt resource. Without it the hook
   that rewrites the domain never runs.
2. **A `virt-launcher` image whose libvirt knows the architecture.** libvirt
   asks the emulator what architecture it is rather than trusting the domain,
   so the architecture has to be compiled in. The patch is about ten lines
   across five tables; the image is published alongside this catalogue.

That image is the carrier for the whole family of machines. A cluster opts in
once, and from then on any tenant installs any machine from the catalogue —
much like a driver package.

## How it works

`OnDefineDomain` is a supported KubeVirt extension point: a sidecar receives
the domain KubeVirt generated and returns a rewritten one. No fork of KubeVirt
is involved, and no sidecar image either — the stock shim runs the script this
chart supplies through a ConfigMap.

The emulator lives in the launcher image; the PROM and the system image arrive
on a volume shared with the container where libvirt runs.
