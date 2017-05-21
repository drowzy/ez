# Ez
A less verbose Elasticsearch DSL

## Dependencies
* Make
* ocaml
* Menhir
* ocaml core std

## Building
```
make
```
## Usage
```
  ___ ____
 / _ \_  /
|  __// /
 \___/___|


A less verbose dsl for elasticsearch


  ez.native [FILENAME]

=== flags ===

  [-d Debug]     a `debug` json string with the original Ez query inlined in the
                 JSON output
  [-q Query]     Wraps output in a `query` object
  [-build-info]  print info about this build and exit
  [-version]     print the version of this build and exit
  [-help]        print this help text and exit
                 (alias: -?)
```
```bash
$ ./ez -q 'foo == "bar"'
  { "query": { "term": { "foo": "bar" } } }
```
### Stdin
```bash
$ echo 'foo == "bar"' > src.ez
$ cat src.ez | ./ez -q
  { "query": { "term": { "foo": "bar" } } }
```
### File
```bash
$ echo 'foo == "bar"' > src.ez
$ ./ez -q src.ez
  { "query": { "term": { "foo": "bar" } } }
```
## Syntax

### Examples
Ez:
```python
foo == 10
```
Elastic json:
```json
{ "query": { "term": { "foo": 10 } } }
```
Ez:
```python
foo != 10 and bar == 10
```
Elastic json:
```json
{
  "query": {
    "bool": {
      "must": [
        { "bool": { "must_not": { "term": { "foo": 10 } } } },
        { "term": { "bar": 10 } }
      ]
    }
  }
}
```
Ez:
```json
foo == 10 or bar == "foo"
```
Elastic json:
```
{
  "query": {
    "bool": {
      "should": [ { "term": { "foo": 10 } }, { "term": { "bar": "foo" } } ]
    }
  }
}
```

Ez:
```python
foo.bar == 10
```
Elastic json:
```json
{ "query": { "term": { "foo.bar": 10 } } }
```

Ez:
```python
foo { foo.bar == "bar" }
```
Elastic json:
```json
{
  "query": {
    "nested": { "path": "foo", "query": { "term": { "foo.bar": "bar" } } }
  }
}
```

Ez:
```python
(foo { foo.bar == 10 and foo.baz == "biz" } and bar.baz <= 10) or biz == "hw"
```

Elastic json:
```json
{
  "query": {
    "bool": {
      "should": [
        {
          "bool": {
            "must": [
              {
                "nested": {
                  "path": "foo",
                  "query": {
                    "bool": {
                      "must": [
                        { "term": { "foo.bar": 10 } },
                        { "term": { "foo.baz": "biz" } }
                      ]
                    }
                  }
                }
              },
              { "range": { "bar.baz": { "lteq": 10 } } }
            ]
          }
        },
        { "term": { "biz": "hw" } }
      ]
    }
  }
}
```
## CURL example
```bash
ez -q 'documentViews.entityType == 1004' | \
curl -H "Content-Type: application/json" -X POST -d @- http://localhost:9200/ordercontainerviews/ordercontainerview/_search
```
## AST
* TODO

## Compiler backends
* Elasticsearch JSON DSL
