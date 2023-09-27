# Web-standard APIs

**stdweb** is a standard Web APIs compatibility library, its purpose is to eliminate Dart-specific syntax.

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

| API                                                                                 | Status |
| ----------------------------------------------------------------------------------- | ------ |
| [URL](https://developer.mozilla.org/en-US/docs/Web/API/URL)                         | ✅     |
| [URLSearchParams](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams) | ✅     |

### File

| API                                                           | Status |
| ------------------------------------------------------------- | ------ |
| [Blob](https://developer.mozilla.org/en-US/docs/Web/API/Blob) | ✅     |
| [File](https://developer.mozilla.org/en-US/docs/Web/API/File) | ✅     |

### JSON

| API                                                                                           | Status |
| --------------------------------------------------------------------------------------------- | ------ |
| [JSON](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON) | ✅     |

### Encoding and decoding

| API                                                                                                                       | Status |
| ------------------------------------------------------------------------------------------------------------------------- | ------ |
| [encodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent) | ✅     |
| [decodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURIComponent) | ✅     |
| [encodeURI](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURI)                   | ✅     |
| [decodeURI](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/decodeURI)                   | ✅     |
| [atob](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/atob)                                   | ❌     |
| [btoa](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/btoa)                                   | ❌     |
| [TextEncoder](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoder)                                               | ❌     |
| [TextDecoder](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder)                                               | ❌     |

### Timeout and interval

| API                                                                             | Status |
| ------------------------------------------------------------------------------- | ------ |
| [setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout)       | ❌     |
| [clearTimeout](https://developer.mozilla.org/en-US/docs/Web/API/clearTimeout)   | ❌     |
| [setInterval](https://developer.mozilla.org/en-US/docs/Web/API/setInterval)     | ❌     |
| [clearInterval](https://developer.mozilla.org/en-US/docs/Web/API/clearInterval) | ❌     |

### Crypto

| API                                                                           | Status |
| ----------------------------------------------------------------------------- | ------ |
| [crypto](https://developer.mozilla.org/en-US/docs/Web/API/Crypto)             | ❌     |
| [SubtleCrypto](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto) | ❌     |
| [CryptoKey](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey)       | ❌     |

### Debugging

| API                                                                         | Status |
| --------------------------------------------------------------------------- | ------ |
| [console](https://developer.mozilla.org/en-US/docs/Web/API/console)         | ❌     |
| [performance](https://developer.mozilla.org/en-US/docs/Web/API/Performance) | ❌     |

### User interaction

| API                                                                        | Status |
| -------------------------------------------------------------------------- | ------ |
| [alert](https://developer.mozilla.org/en-US/docs/Web/API/Window/alert)     | ❌     |
| [confirm](https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm) | ❌     |
| [prompt](https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt)   | ❌     |

## TODO

- [ ] User interaction
- [ ] Crypto
- [ ] Debugging
- [ ] Timeout and interval
- [ ] Encoding and decoding
  - [ ] atob
  - [ ] btoa
  - [ ] TextEncoder
  - [ ] TextDecoder
