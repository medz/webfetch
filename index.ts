URLSearchParams;

const a = new URLSearchParams();
a.append('a', '1');
a.append('a', '1');

for (const [key, value] of a.keys()) {
  console.log(key, value);
}
