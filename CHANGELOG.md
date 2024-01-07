# 0.0.15

1. fix headers not copy `set-cookie` headers.
2. fix `Request` and `Response` fromdata parse not support `x-www-form-urlencoded` format.

# 0.0.14

1. fix `Response` and `Request` clone failure.
2. fix that the response fully complies with [MDN Response](https://developer.mozilla.org/zh-CN/docs/Web/API/Response) conventions, and now all attributes are read-only
3. fix request compies with [MDN Request](https://developer.mozilla.org/zh-CN/docs/Web/API/Request) conventions, and now all attributes are read-only
4. support nullable `Request` body
5. support nullable `Response` body

# 0.0.13

1. Fix Flutter project cannot rely on the latest version
2. Update dart sdk version to `^3.2.0`

# 0.0.12

1. Remove `http` package dependency.
2. Support custom HTTP client.
3. Fix `window` not found.

# 0.0.11

- **BUG**: Fix stream data conversion failure when request body is empty.

# 0.0.10

- feat: Support `TypedData` body encoding request/response.

# 0.0.9

- feat: `Response` support `URLSearchParams` body encoding.

# 0.0.8

Fix the response properties are not set correctly.

# 0.0.7

It's not important to improve the rating

# 0.0.6

- feat: Add `Response.redirect` factory constructor.
- fix: Fix `Response` not support `null` body.

# 0.0.5

A Dart implementation of the Web Fetch API that allows you to make requests and process results just like using fetch in a browser.

# 0.0.4

Update http package.

# 0.0.3

- Fix `Response.json` to returns type defined.

# 0.0.2

- Fix `decodeURIComponent` and `decodeURI` to returns type defined.
- Fix ` Headers`` not filtering  `set-cookie`.
