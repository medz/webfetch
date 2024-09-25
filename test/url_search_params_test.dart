import 'package:test/test.dart';
import 'package:webfetch/webfetch.dart';

void main() {
  group('URLSearchParams', () {
    test('constructor with string', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.get('foo'), equals('1'));
      expect(params.get('bar'), equals('2'));
    });

    test('constructor with map', () {
      final params = URLSearchParams({'foo': '1', 'bar': '2'});
      expect(params.get('foo'), equals('1'));
      expect(params.get('bar'), equals('2'));
    });

    test('constructor with iterable', () {
      final params = URLSearchParams([('foo', '1'), ('bar', '2')]);
      expect(params.get('foo'), equals('1'));
      expect(params.get('bar'), equals('2'));
    });

    test('empty constructor', () {
      final params = URLSearchParams();
      expect(params.size, equals(0));
    });

    test('constructor with invalid type throws error', () {
      expect(() => URLSearchParams(42), throwsA(isA<UnsupportedError>()));
    });
    test('handling of special characters', () {
      final params = URLSearchParams('foo=hello+world&bar=a+b&baz=c%2Bd');
      expect(params.get('foo'), equals('hello world'));
      expect(params.get('bar'), equals('a b'));
      expect(params.get('baz'), equals('c+d'));

      final params2 =
          URLSearchParams('key1=value+with+spaces&key2=++&key3=no+spaces');
      expect(params2.get('key1'), equals('value with spaces'));
      expect(params2.get('key2'), equals('  '));
      expect(params2.get('key3'), equals('no spaces'));
    });

    test('multiple values for the same key', () {
      final params = URLSearchParams('foo=1&foo=2&foo=3');
      expect(params.getAll('foo'), equals(['1', '2', '3']));
    });

    test('empty value', () {
      final params = URLSearchParams('foo=&bar');
      expect(params.get('foo'), equals(''));
      expect(params.get('bar'), equals(''));
    });

    test('URL encoded characters', () {
      final params = URLSearchParams('foo=%3D%26%3D');
      expect(params.get('foo'), equals('=&='));
    });

    test('constructor with leading ?', () {
      final params = URLSearchParams('?foo=1&bar=2');
      expect(params.get('foo'), equals('1'));
      expect(params.get('bar'), equals('2'));
    });

    test('constructor throws on double ??', () {
      expect(() => URLSearchParams('??foo=1&bar=2'), throwsFormatException);
    });

    test('entries method', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.entries().toList(), equals([('foo', '1'), ('bar', '2')]));
    });

    test('forEach method', () {
      final params = URLSearchParams('foo=1&bar=2');
      final result = <String, String>{};
      // ignore: avoid_function_literals_in_foreach_calls
      params.forEach((value, key) {
        result[key] = value;
      });
      expect(result, equals({'foo': '1', 'bar': '2'}));
    });

    test('keys method', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.keys().toList(), equals(['foo', 'bar']));
    });

    test('values method', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.values().toList(), equals(['1', '2']));
    });

    test('sort method', () {
      final params = URLSearchParams('c=3&a=1&b=2');
      params.sort();
      expect(params.toString(), equals('a=1&b=2&c=3'));
    });

    test('toString method', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.toString(), equals('foo=1&bar=2'));
    });

    test('size property', () {
      final params = URLSearchParams('foo=1&bar=2&baz=3');
      expect(params.size, equals(3));
    });

    test('append method', () {
      final params = URLSearchParams();
      params.append('foo', '1');
      params.append('foo', '2');
      expect(params.getAll('foo'), equals(['1', '2']));
    });

    test('delete method', () {
      final params = URLSearchParams('foo=1&bar=2&foo=3');
      params.delete('foo');
      expect(params.has('foo'), isFalse);
      expect(params.has('bar'), isTrue);
    });

    test('get method', () {
      final params = URLSearchParams('foo=1&bar=2&foo=3');
      expect(params.get('foo'), equals('1'));
      expect(params.get('baz'), isNull);
    });

    test('getAll method', () {
      final params = URLSearchParams('foo=1&bar=2&foo=3');
      expect(params.getAll('foo'), equals(['1', '3']));
      expect(params.getAll('bar'), equals(['2']));
      expect(params.getAll('baz'), isEmpty);
    });

    test('has method', () {
      final params = URLSearchParams('foo=1&bar=2');
      expect(params.has('foo'), isTrue);
      expect(params.has('baz'), isFalse);
    });

    test('set method', () {
      final params = URLSearchParams('foo=1&bar=2');
      params.set('foo', '3');
      expect(params.get('foo'), equals('3'));
      params.set('baz', '4');
      expect(params.get('baz'), equals('4'));
    });
  });
}
