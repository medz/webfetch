ReadableStream;

const a = {
  get() {
    return 1;
  },
  set() {
    return 2;
  },
};

console.log(a);
