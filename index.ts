FormData;

const form = new FormData();
form.append('name', 'John');
form.append('name', 'Seven');

for (const key of form.keys()) {
  console.log(key);
}
