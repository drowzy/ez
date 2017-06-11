# Ez
A less verbose Elasticsearch DSL

```
  ___ ____
 / _ \_  /
|  __// /
 \___/___|


A less verbose dsl for elasticsearch


  ez [FILENAME]

=== flags ===

  [-d Debug]     a `debug` json string with the original Ez query inlined in the
                 JSON output
  [-q Query]     Wraps output in a `query` object
  [-build-info]  print info about this build and exit
  [-version]     print the version of this build and exit
  [-help]        print this help text and exit
                 (alias: -?)
```

## Building

This package uses OASIS to generate its build system. See section OASIS for
full information.

### Dependencies

In order to compile this package, you will need:

* ocaml
* findlib
* yojson
* menhirLib
* core_kernel
* cmdliner

The easiest way is to create a local switch, pin the package and install the dependencies specified in the opam file:
```bash
opam switch install ez_switch -A 4.04.1
opam pin add ez . --no-action
opam install ez --deps-only
# Oasis & oUnit is required for development so run the deps.sh script to
# install them
./deps.sh
```

### Tests

Tests are turned off by default, they can be enabled with:

```bash
ocaml setup.ml -configure --enable-tests
```

After that it's just a matter of running `make test` to run the suite


### Installing

1. Uncompress the source archive and go to the root of the package
2. Run `ocaml setup.ml -configure`
3. Run `ocaml setup.ml -build`
4. Run `ocaml setup.ml -install`

or with `make`

```bash
make
make install

```

### Uninstalling

1. Go to the root of the package
2. Run 'ocaml setup.ml -uninstall'

### OASIS

OASIS is a program that generates a setup.ml file using a simple '_oasis'
configuration file. The generated setup only depends on the standard OCaml
installation: no additional library is required.

## Usage

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
## Syntax reference
Identifiers | Description
--- | ----
x | Defines a variable x
x.y.z | Identifier with projection. Projections are treated as normal variables

Base Types | Description
--- | ---
123 | Integer
1.234 | Float
"foo" | String

Boolean logic | Description | Elastic
------------- | ----------- | -------
x or y | one or the other | should
x and y | both | must
not x | not |
( x ) | precedence | N\A
x == y | Equals | term
x != y | Not equals | must_not -> term
x < y | Less than | lt
x <= y | Less than or equal to | lteq
x > y | Greater than | gt
x >= y | Greater than or equal to | gteq

Expressions | Descriptions | Example
----------- | ------------ | -------
`~r"json>"`  | The raw expr allows for inserting an arbitrary elastic json expression | `~r"{\"term:\" { \"foo\": 10 }}"`
`<id> { expr }` | Creates a nested scope with `id` as the path. and the expr in the block will be a part of the nested query. | `foo { foo.bar == 10 }`
`<id> in [<value>,<value>]` | is the identifier value in the array | `foo in [10, 20]`

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
foo in ["bar", "baz"]
```
Elastic json:
```json
{
  "query": {
    "terms": {
      "foo": [
        "bar",
        "baz"
      ]
    }
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

## Compiler service

The `ez_cs` binary is compiler service over HTTP

See `ez_cs --help` for flags & options
### Running
```
./ez_cs --verbose --debug --port 5000 [3000]
```
The verbose flag will print request/response information to stdout.

### Routes

1 Routes:
`> /compile (PUT)`
