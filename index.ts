const form = new FormData();
form.append('a', '1');
form.append('b', '2');

const blob = new Blob(['Hello, world!']);
form.append('file', blob, 'hello.txt');

const request = new Request('http://localhost:3000', {
  body: form,
});

console.log(await request.clone().text());
console.log(await request.text());
