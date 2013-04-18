#!/usr/bin/ruby
require 'rubygems'
require 'yaml'
require 'csv'
require 'ya2yaml'

require 'yaml2csv/railtie' if defined?(Rails)

require 'yaml2csv/hash_extensions'
Yaml2csv.extend_hash

module Yaml2csv
  # Convert a string containing YAML data to a CSV string
  def self.yaml2csv(yamldata, options = {})
    hash = YAML::load(yamldata)

    CSV.generate do |csv_writer|
      hash.to_enum(:walk).each do |path, key, value|
        strvalue = value.is_a?(String) ? value : value.inspect
        csv_writer << [path.join("/"), key, strvalue]
      end
    end
  end
  
  # Convert a string containing CSV values to a YAML string
  def self.csv2yaml(csvdata, options = {})
    walk_array = []

    CSV.parse(csvdata) do |row|
      walk_array << [row[0].split("/").map(&:to_s), row[1].to_s, row[2].to_s]
    end

    hash = Hash.unwalk_from_array(walk_array)
    hash.ya2yaml.gsub(/\s+$/, '') + "\n"
  end  

  # Convert a string containing YAML data to an array
  def self.yaml2array(yamldata, options = {})
    if options.has_key?(:language)
      hash = YAML::load(yamldata)[options[:language]]
    else
      hash = YAML::load(yamldata)
    end

    array = Array.new

    hash.to_enum(:walk).each do |path, key, value|
      strvalue = value.is_a?(String) ? value : value.inspect
      strvalue = strvalue == 'nil' ? '' : strvalue  # TODO: Use regexp
      dotted_path = path.join(".")

      if block_given?
        tmpvalue = yield(key, path, strvalue)
        strvalue = tmpvalue.to_s unless tmpvalue.nil?
      end

      if dotted_path.length <= 0
        array << [key, strvalue]
      else
        array << [dotted_path + '.' + key , strvalue]
      end
    end

    array
  end

  # Convert a string containing CSV values to a data
  def self.csv2data(csvdata, options = {})
    walk_array = []

    value_column = options.has_key?(:value_column) ? options[:value_column] : 2
    path_prefix = options.has_key?(:path_prefix) ? options[:path_prefix] : nil

    CSV.parse(csvdata, {:headers => true}) do |row|
      if path_prefix.nil?
        path = row[0].split(".")
      else
        path = [path_prefix].concat(row[0].split("."))
      end
      
      key = path.pop # destructive
      value = row[value_column].to_s

      if block_given?
        value = yield(key, path, value)
        value = row[value_column].to_s if value.nil?
      end
      
      walk_array << [path.map(&:to_s), key.to_s, value]
    end

    hash = Hash.unwalk_from_array(walk_array)
    data = hash.ya2yaml.gsub(/\s+$/, '') + "\n"
    data.sub(/^---\n/,'')
  end  
end
