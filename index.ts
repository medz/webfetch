Blob;

const a = new Blob(['你好']);
const b = new Blob(['世界']);

const c = new Blob([a, b]);

// console.log(await c.slice(0, 1).text()); // 6
