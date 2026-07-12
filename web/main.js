async function run() {
  const output = document.getElementById('output');
  const status = document.getElementById('status');

  let memory;

  const decoder = new TextDecoder();

  const importObject = {
    wasi_snapshot_preview1: {
      fd_write: (fd, iovs, iovsLen, nwritten) => {
        if (fd !== 1 && fd !== 2) return 8;
        const view = new DataView(memory.buffer);
        let total = 0;
        let text = '';
        for (let i = 0; i < iovsLen; i++) {
          const ptr = view.getUint32(iovs + i * 8, true);
          const len = view.getUint32(iovs + i * 8 + 4, true);
          const bytes = new Uint8Array(memory.buffer, ptr, len);
          text += decoder.decode(bytes);
          total += len;
        }
        view.setUint32(nwritten, total, true);
        output.textContent += text;
        return 0;
      }
    },
    __moonbit_time_unstable: {
      instant_now: () => performance.now(),
      instant_elapsed_as_secs_f64: (start) => (performance.now() - start) / 1000
    }
  };

  try {
    const response = fetch('tqdmoon.wasm');
    const { instance } = await WebAssembly.instantiateStreaming(response, importObject);
    memory = instance.exports.memory;

    status.textContent = 'Running _start()...';
    output.textContent = '';
    instance.exports._start();
    status.textContent = 'Done.';
  } catch (err) {
    output.textContent = 'Error: ' + err.message;
    status.textContent = '';
    console.error(err);
  }
}

run();
