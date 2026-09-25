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


  '1.step.0': `Let the system boot — a couple of seconds. Work out what is on
    the screen:
    <ul style="margin:6px 0 0 -18px">
      <li><b>Upper right</b> — the log. It holds one line:
        <code>Oberon V5 NW 14.4.2013</code>. This is where the system writes
        what is going on.</li>
      <li><b>Lower right</b> — <code>System.Tool</code>. A list of commands.
        Plain text.</li>
      <li><b>The black strips</b> above each window are its title and its own
        commands.</li>
      <li><b>The left side is empty, and that is not a fault.</b> The screen is
        divided into vertical tracks. The left one is free space for windows to
        open into. Until something opens, it stays white.</li>
    </ul>`,

  '1.step.1': `Now run a command. In the lower window find the words
    <code>System.ShowModules</code> and click them with the <b>middle</b>
    button, precisely on the words. No middle button — hold
    <kbd class="k-alt">Alt</kbd> and click with the left one.
    <br><br>
    <b>What should happen.</b> A third window opens at the lower right with the
    black title <code>System.ShowModules</code>, holding exactly this — a module
    name, two addresses in memory and a number. Your addresses may differ in the
    last digits; that is normal. What matters is that a window with a list
    appeared. The command was not "pressed" — it opened a window with an answer.
    <br><br>
    If nothing happened, you most likely missed the word, or used the ordinary
    left button. The left button only places the caret; it runs nothing.`,

  '1.step.2': `Now populate the empty track on the left. A middle click on
    <code>Hilbert.Draw</code> and it stops being white: a window titled
    <code>Hilbert</code> opens there, drawing a Hilbert curve. Beside it are
    <code>Sierpinski.Draw</code>, <code>Stars.Open</code> and
    <code>Blink.Run</code> — they open on the left too.
    <br><br>
    <b>And about the marks in the command list.</b> Not every command opens a
    window, and its notation says so:
    <ul style="margin:6px 0 0 -18px">
      <li><code>Name.Command</code> with no mark — simply runs;</li>
      <li><code>~</code> at the end — the command expects <b>parameters before
        it</b>. That is why clicking <code>System.Free ~</code> does nothing:
        there is nothing to free, no module names are written before the
        <code>~</code>. The answer would go to the log at the upper right, not
        into a new window;</li>
      <li><code>↑</code> — the parameter comes from whatever you selected
        beforehand;</li>
      <li><code>@</code> — the command works on the text in the marked
        window.</li>
    </ul>`,

  '2.step.0': `Place the caret at the end of <code>System.Tool</code>, type
    <code>Edit.Open Hello.Mod ~</code> and run it. An empty window opens on the
    left. Click inside it with the left button and type:
    <pre>MODULE Hello;
  VAR n*: INTEGER;
  PROCEDURE Add*(x: INTEGER);
  BEGIN n := n + x
  END Add;
BEGIN n := 0
END Hello.</pre>
    Then <code>Edit.Store</code> in that window's title.`,
  '2.step.1': 'Now compile it: <code>ORP.Compile Hello.Mod ~</code>.',

  '3.step.0': 'Look at a finished module first. Press "Check" — it will show the key of <code>Blink.rsc</code> as it sits on the image.',
  '3.step.1': 'Rebuild it: <code>ORP.Compile Blink.Mod/s ~</code>. The source has not changed, so the interface is the same — and the key must stay the same, even though the file will be rewritten.',
  '3.step.2': 'And now, what this was for. Every module stores the keys of those it imports. Press "Check": we will compare the key <code>Oberon.rsc</code> remembers for <code>Texts</code> against the key <code>Texts.rsc</code> carries itself.',

  '4.step.0': 'Wait for the boot and write rubbish into the framebuffer: address <code>E7F00</code>, value <code>FFFFFFFF</code>. The screen will be spoiled and the system will survive — it does not know the difference between its own memory and anyone else\'s.',
  '4.step.1': 'Now spoil the <b>code</b>. The panel shows the current instruction counter — write the value <code>E7FFFFFF</code> at that address. That is a "jump to itself": the machine will spin on one instruction forever.',

  '5.step.0': 'Wait for the boot and press "Check" — this records the current counter readings.',
  '5.step.1': 'Divide cycles by instructions over the whole run and enter the result to two decimal places.',
  '5.step.2': 'Now place the caret at the end of <code>System.Tool</code>, type <code>ORP.Compile Math.Mod/s ~</code> and run it. Then enter how many cycles per instruction that came to.',

  '6.step.0': 'Place the caret at the end of <code>System.Tool</code> and run it as one command: <code>ORP.Compile ORS.Mod/s ORB.Mod/s ORG.Mod/s ORP.Mod/s PIO.Mod/s ~</code>',
  '6.step.1': 'Now the same thing, one module per command. The last one is enough: <code>ORP.Compile PIO.Mod/s ~</code>.',

  '7.step.0': 'Wait for the boot. Note the size of <code>Math.rsc</code> — the check will show it below.',
  '7.step.1': 'Place the caret at the end of <code>System.Tool</code> (left click), type <code>ORP.Compile Math.Mod/s ~</code> and run it with a middle click.',

  '8.step.0': 'Build the compiler\'s scanner: <code>ORP.Compile ORS.Mod/s ~</code>. This is generation 1 — built by the compiler that was sitting on the disk.',
  '8.step.1': 'Unload the compiler from memory: <code>System.Free ORP ORG ORB ORS ~</code>. Without this the next build runs on the old code still in memory, and the experiment proves nothing.',
  '8.step.2': 'Build <code>ORS.Mod</code> again. This time the freshly built compiler does it — generation 2.',

  '9.step.0': `Create <code>Edit.Open Idx.Mod ~</code> and type (the word
    <code>MODULE</code> on a line of its own — that matters later):
    <pre>MODULE Idx;
  VAR a: ARRAY 100 OF INTEGER;
  PROCEDURE Sum*(n: INTEGER): INTEGER;
    VAR i, s: INTEGER;
  BEGIN s := 0; i := 0;
    WHILE i &lt; n DO s := s + a[i]; INC(i) END;
    RETURN s
  END Sum;
END Idx.</pre>
    Save it and build: <code>ORP.Compile Idx.Mod/s ~</code>.`,
  '9.step.1': 'Now place the caret at the very start of the second line, before <code>Idx;</code>, and type a star. You get <code>MODULE *Idx;</code>. Save and build again.',

  '2.title': 'Your first module',
  '3.title': 'The interface key',
  '4.title': 'There is no memory protection here',
  '5.title': 'Cycles per instruction',
  '6.title': 'The heap runs out mid-command',
  '7.title': 'The system rebuilds itself',
  '8.title': 'Fixed point: two generations',
  '9.title': 'Inside the code generator',
};
