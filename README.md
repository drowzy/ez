# RQL - Retard Query Language
A language for simpletons

## Dependencies
* Make
* ocaml
* Menhir
* ocaml core std
## Building
```
make
```
## Syntax

RQL:
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

RQL:
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
RQL:
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
## Compiler backends
* Elasticsearch JSON DSL
