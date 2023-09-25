Blob;

const stream = new Blob(['hello world']);
const text = 'xxx';

const blob = new Blob([text, stream]);

console.log(await blob.slice(2, 4).text());
