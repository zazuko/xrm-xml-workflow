# Template to transform JSON, XML or CSV to RDF

This is a running example of a [Barnard59](#about-barnard59) pipeline that convert JSON, XML or CSV files to RDF and (optionally) upload it into a store.

This repository contains:

- Sample [XRM mappings](./mappings) for JSON, XML and CSV and some [example files](./input)
- A [pipeline](./pipelines/main.ttl) that converts the input file to RDF
- A default GitHub Action configuration that runs the pipeline and creates an artifact for download

## Quick start

* Install the dependencies

```markdown
npm install
```

* Run the barnard59 workflow to produce a file, for example:

```sh
npm run json-to-file
```

You will see the output of the pipeline process, if all went well, the RDF file was generated at `./output/transformed.nt`

What the pipeline did is to use a [mapping](./src-gen/mapping-json.carml.ttl) to transform an [input file](./input/example.json) using a [CARML service](https://github.com/zazuko/carml-service) instance.

From now own you can [write your mapping](#writing-your-mappings) and start producing RDF. You can choose if you produce local files, or you upload them [into a store](#upload-to-the-store). 

## Using the template

This is a GitHub template repository. It will not be declared as "fork" once you click on the `Use this template` button above. Simply do that, start adding your data sources and create the mappings accordingly.

## Writing your mappings

You can choose to write the mappings by hand in the `src-gen` directory, or write XRM through a [plugin](https://zazuko.com/products/expressive-rdf-mapper/). This is by far a better experience since it provides autocomplete, code-lookup and a type-safety. The XRM will be easier to maintain in the future.

Set up a mapping to do a transformation:

1. Copy the source file to the `input` directory
2. Create/adjust the XRM files in the [mappings](./mappings) directory, the plugin will produce a CARML or RML mapping in the [src-gen](./src-gen) to transform the data.
3. Execute one of the run-scripts to convert your data.

Make sure to commit the `input` and `src-gen` directories if you want to build it using GitHub Actions. Also is convenient to keep track of the `mappings` directory.

Tip: When developing a mapping to RDF sometimes is easier to start with a small sample of what you want to transform. When the mapping is ok you can use it to convert the whole dataset.

See [Further reading](#further-reading) for more information about the XRM mapping language.

## Run the pipeline

The default pipeline can be run with `npm run json-to-file`. It will:

- Read the JSON input file (default: `input/example.json`)
- Convert it to RDF
- Write it into a file as N-Triples (default: `output/transformed.nt`)

To convert XML input, run `npm run xml-to-file`.

To convert CSV input, run `npm run csv-to-file`.


### Upload to the store

There are additional pipelines configured in `package.json`:

* `file-to-store(-dev)`: Uploads the generated output file to an RDF store via SPARQL Graph Store Protocol
* `json-to-store(-dev)`: Directly uploads to an RDF store (direct streaming in the pipeline) via SPARQL Graph Store Protocol

If you want to test the upload to an RDF store, a default [Apache Jena Fuseki](https://jena.apache.org/index.html) installation with a database `data` on port `3030` should work out of the box.

### Configure the pipeline

Pipeline configuration is done via environment variables and/or adjusting default variables in the pipeline itself. If you want to pass another default, have a look at the `--variable=XYZ` samples in `package.json` or consult the [barnard59 documentation](https://github.com/zazuko/barnard59/blob/master/packages/cli/README.md#passing-arguments-to-the-pipeline). If you want to adjust it in the pipeline, open the file [pipelines/main.ttl](pipelines/main.ttl) and edit `<defaultVars> ...`.


## Watch script (dev-mode)

While developing or changing the mapping, it might be useful to run the transformation automatically whenever the mapping file changes. This can be helpful in order to get quick feedback and validate modifications incrementally.

There is a simple script that shows how this could be done: `src-gen/watch.sh`

Running that script is alternative to running the pipeline as described above. The watch script requires that `inotifywait` is installed on the system. The script downloads and invokes carml-jar directly (different from the pipeline which is using carml-service).


## About barnard59

This template is built on top of our [Zazuko](https://zazuko.com/) [barnard59](https://github.com/zazuko/barnard59) pipelining system. It is a [Node.js](https://nodejs.org) based, fully configurable pipeline framework aimed at creating RDF data out of various data sources. Unlike many other data pipelining systems, barnard59 is configured instead of programmed. In case you need to do pre- or post-processing, you can implement additional pipeline steps written in JavaScript.

barnard59 is streaming and can be used to convert very large data sets with a small memory footprint.

## Other template repositories

We provide additional template repositories:

* [xrm-r2rml-workflow](https://github.com/zazuko/xrm-r2rml-workflow):  A template repository for converting complete relational databases to RDF using the R2RML specification and Ontop as mapper.
* [xrm-csvw-workflow](https://github.com/zazuko/xrm-csvw-workflow):  A template repository for converting CSV files to RDF using a CARML mapping.

## Further reading

* [Expressive RDF Mapping Language (XRM)](https://zazuko.com/products/expressive-rdf-mapper/) and the [documentation](https://github.com/zazuko/expressive-rdf-mapper) for details about the domain-specific language (DSL).
* [CSV on the Web: A Primer](https://www.w3.org/TR/tabular-data-primer/): Introduction to the CSVW mapping language, which is generated by XRM and consumed by barnard59. This is only as a reference, you do not have to learn about it, XRM generates that for you.
* [SPARQL 1.1 Graph Store HTTP Protocol](https://www.w3.org/TR/sparql11-http-rdf-update/): The SPARQL Graph Store specification used to upload data to an RDF store like Apache Jena Fuseki

