# Yaml2Csv

Transform YAML file into CSV and backwards. CSV files contain
triplets [path, key, value]. For example:

```yaml:
path1:
  path11:
    key11a: value11a
    key11b: value11b
  path12:
    path121:
      key121a: value121a
path2:
  key2a: value2a
```
Will be converted into:

```csv:
path1/path11,key11a,value11a
path1/path11,key11b,value11b
path1/path12/path121,key121a,value121a
path2,key2a,value2a
```

YAML source files should contain only hashes and string values. While non-string 
values (i.e. arrays, booleans) are allowed, they will be treated as strings 
thus their original format will be lost.

## Usage 

### As a gem

In your Gemfile:

```ruby:
gem 'yaml2csv'
```

In your code:

```ruby:
output_string = Yaml2csv::yaml2csv(input_string)
output_string = Yaml2csv::csv2yaml(input_string)
```

### rake task

Convert file.yml into CSV format:

```shell:
$ rake yaml2csv:yaml2csv INPUT=file.yml OUTPUT=file.csv
```

Convert file.csv into YAML format:

```shell:
$ rake yaml2csv:csv2yaml INPUT=file.csv OUTPUT=file.yml
```