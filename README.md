# Web-standard APIs

**stdweb** is a standard WEB APIs compatibility library, its purpose is to eliminate Dart-specific syntax.

## Why do you need **stdweb**?

If you have experience with JavaScript applications on the web, Node.js, Bun.js or Deno runtimes, then **stdweb** will feel familiar to you. You no longer need to learn Dart's various API implementations in depth, you can start using Dart directly from the APIs we are familiar with!

## How to use **stdweb**?

**stdweb** is a Dart package, you can use it in your project by adding the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  stdweb: latest
```

## Web APIs compatibility

### HTTP

| API                                                                   | Status |
| --------------------------------------------------------------------- | ------ |
| [fetch](https://developer.mozilla.org/en-US/docs/Web/API/fetch)       | ✅     |
| [Headers](https://developer.mozilla.org/en-US/docs/Web/API/Headers)   | ✅     |
| [Request](https://developer.mozilla.org/en-US/docs/Web/API/Request)   | ✅     |
| [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) | ✅     |
| [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData) | ✅     |

### URLs

| API                                                                                                                       | Status |
| ------------------------------------------------------------------------------------------------------------------------- | ------ |
| [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL)                                                               | ✅     |
| [URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)                                       | ✅     |
| [encodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent) | ✅     |
| [decodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent) | ✅     |
| [encodeURI](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURI)                   | ✅     |
| [decodeURI](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURI)                   | ✅     |

### File

| API                                                           | Status |
| ------------------------------------------------------------- | ------ |
| [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) | ✅     |
| [File](https://developer.mozilla.org/en-US/docs/Web/API/File) | ✅     |

### JSON

| API                                                                                           | Status |
| --------------------------------------------------------------------------------------------- | ------ |
| [JSON](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON) | ✅     |
