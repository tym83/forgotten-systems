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

  '2.title': 'Your first module',
  '3.title': 'The interface key',
  '4.title': 'There is no memory protection here',
  '5.title': 'Cycles per instruction',
  '6.title': 'The heap runs out mid-command',
  '7.title': 'The system rebuilds itself',
  '8.title': 'Fixed point: two generations',
  '9.title': 'Inside the code generator',
};
