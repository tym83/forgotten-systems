// Обёртка рабочего потока: вся логика в worker-core.js, чтобы её можно было
// проверить в node, где нет ни `self`, ни `postMessage`.
import { createHandler } from './worker-core.js';

const handle = createHandler((msg, transfer) => self.postMessage(msg, transfer || []));

// Очередь: сообщения приходят быстрее, чем считается кадр, и обрабатывать их
// внахлёст нельзя — машина одна.
let chain = Promise.resolve();
self.onmessage = e => { chain = chain.then(() => handle(e.data)).catch(err =>
  self.postMessage({ t: 'error', message: String(err && err.stack || err) })); };
