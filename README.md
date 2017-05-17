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
### Stream
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

### Stdin
```
$ ./ez -q 'foo == "bar"'
  { "query": { "term": { "foo": "bar" } } }
```
## Syntax

### Examples
Ez:
```python
foo == 10
```
Elastic json
```json
{
  "query": {
    "term": {"foo": 10}
  }
}
```

Ez:
```python
foo != 10 and bar == 10
```
Elastic json
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
```python
foo.bar == 10
```
Elastic json
```json
{
  "query": {
    "nested": {
      "path": "foo",
      "query": {
        "term": { "foo.bar": 10 }
      }
    }
  }
}
```

Ez
```
(foo.bar == 10 and bar.baz <= 10) or biz == "hw"
```

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
                  "query": { "term": { "foo.bar": 10 } }
                }
              },
              {
                "nested": {
                  "path": "bar",
                  "query": { "range": { "bar.baz": { "lteq": 10 } } }
                }
              }
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
## Ez AST
* TODO

## Compiler backends
* Elasticsearch JSON DSL
