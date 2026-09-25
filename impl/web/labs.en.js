/*
 * Английские тексты лабораторий.
 *
 * Наложение поверх labs.js: русский остаётся там, где написан, а этот файл
 * подменяет его при выборе английского. Так переводится постепенно и без
 * риска сломать работающее — чего нет здесь, то просто останется русским.
 *
 * Ключи: <номер>.<поле> — intro, hint, payoff, title, level,
 *        <номер>.step.<индекс> для текста шага.
 */
export const EN = {
  'level.смотреть': 'observe',
  'level.менять':   'modify',
  'level.ломать':   'break',
  'level.измерять': 'measure',
  'level.строить':  'build',

  '1.title': 'The system on real hardware',
  '1.intro': `What runs under the canvas is not an emulator but <b>RISC5.v</b>
    by Niklaus Wirth — that very Verilog, stepped cycle by cycle. Everything
    you see was drawn by the Oberon system of 1986 on that processor.
    <br><br>
    <b>The interface is unlike anything else, and that is the main thing to
    grasp.</b> There are no buttons at all. <i>Any word on the screen</i> can
    be a command, provided it looks like <code>Module.Command</code>. You run
    it with a <b>middle</b> click straight on the text — not on a button, not
    through a menu, on the word itself. The list in the lower window is simply
    text somebody once typed because it was convenient.`,

  '1.hint': `A middle click is <kbd class="k-alt">Alt</kbd> plus the left
    button, or pick the middle button from the "mouse" list above. Aim exactly
    at the words of the command: the system looks at which word you hit. Left
    places the caret, right selects — only middle runs. And
    <kbd>Shift</kbd>+left sends two buttons at once: that is the "interclick",
    without which part of the system is out of reach.`,
  '1.payoff': `Count the lines in the window that opened. <b>Thirteen.</b>
   That is the whole operating system: memory and disk, files and directory,
   the module loader, keyboard, mouse, screen, windows, fonts, texts, the
   editor, the main loop, commands. Not a kernel without drivers, not a part —
   all of it. The addresses show it occupies <b>101 kilobytes</b>. On a modern
   machine a single <code>lsmod</code> prints a hundred lines, and that is not
   even the system, just a list of its pieces.`,


  '2.intro': `Here you will type a module into the system's own editor, save
    it and compile it. Nothing beyond the mouse and keyboard is needed — the
    editor, the compiler and the file system are already inside.`,

  '3.intro': `Oberon has no header files: the compiler extracts a module's
    interface itself and computes a <b>key</b> over it. Every module remembers
    the keys of everything it imports, and the system checks them when
    loading. Here you will watch that mechanism catch you in the act.`,

  '4.intro': `This machine has no memory management unit, no protection rings
    and no privilege separation. Any word of RAM is reachable by any code. The
    panel on the right writes straight into the machine's memory — exactly what
    any stray pointer would do.`,

  '5.intro': `This machine has no cache, no branch prediction and no
    out-of-order execution. Execution time is therefore a matter of a table and
    does not depend on what the machine happens to be doing. Here you will check
    that for yourself — the instruction and cycle counters come from the
    circuit, not from our arithmetic.`,

  '6.intro': `Oberon's garbage collector runs <b>between</b> commands, not
    inside them. While a command is running, memory is only consumed. Here you
    will walk into that yourself — and find the way around it.`,

  '7.intro': `The Oberon compiler is written in Oberon and sits on this same
    disk. Here you will rebuild the <code>Math</code> module and discover that
    the binary shipped on the image is <b>out of date</b>: it was built by a
    different version of the compiler than the one on the disk beside it.`,

  '8.intro': `"The compiler builds itself" proves nothing on its own: a
    compiler with a bug will build itself too. The proof is two generations
    agreeing. Here you will obtain it by hand.`,

  '9.intro': `Before every index operation with a variable subscript the code
    generator emits two instructions: a comparison and a conditional branch. One
    variable named <code>check</code> in <code>ORG.Mod</code> governs this, and
    it is switched on in an unexpected way.`,


  '2.hint': 'A star after a name means it is exported. The full stop after the final END is required. When the compiler objects, it prints the position as a character offset from the start of the file.',
  '3.hint': 'The key is computed over the interface, not the code: editing the body of a procedure leaves it alone, adding an exported name changes it.',
  '4.hint': 'Addresses are hexadecimal, without 0x. The instruction counter moves all the time — enter the value you saw at the moment you wrote, and try again if you missed.',
  '5.hint': 'The counters in the header refresh four times a second. Dividing one by the other can be done in your head: both are shown in millions.',
  '6.hint': 'All three commands can be typed as three lines at once, then run one after another with a middle click.',
  '7.hint': 'PIO.rsc is absent from the image to begin with — which is why its appearance is the proof that compilation ran to the end.',
  '8.hint': 'A tilde at the end is required: it closes the command\'s parameter list.',
  '9.hint': 'Click to the left of the first character of the second line, but inside the window frame. If the star lands inside a word, the compiler will say "must start with MODULE".',

  '2.title': 'Your first module',
  '3.title': 'The interface key',
  '4.title': 'There is no memory protection here',
  '5.title': 'Cycles per instruction',
  '6.title': 'The heap runs out mid-command',
  '7.title': 'The system rebuilds itself',
  '8.title': 'Fixed point: two generations',
  '9.title': 'Inside the code generator',
};
