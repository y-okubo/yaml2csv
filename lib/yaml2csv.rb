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
  def self.yaml2array(yamldata, language, options = {})
    hash = YAML::load(yamldata)[language]
    array = Array.new

    hash.to_enum(:walk).each do |path, key, value|
      strvalue = value.is_a?(String) ? value : value.inspect
      strvalue = strvalue == 'nil' ? '' : strvalue
      dot_path = path.join(".")
      if dot_path.length <= 0
        array << [key, strvalue]
      else
        array << [dot_path + '.' + key , strvalue]
      end
    end

    array
  end

  # Convert a string containing CSV values to a hash
  def self.csv2hash(csvdata, column, prefix, options = {})
    walk_array = []

    CSV.parse(csvdata, {:headers => true}) do |row|
      full_path = [prefix].concat(row[0].split("."))
      key = full_path.pop # 破壊的
      path = full_path
      walk_array << [path.map(&:to_s), key.to_s, row[column].to_s]
    end

    hash = Hash.unwalk_from_array(walk_array)
    hash.ya2yaml.gsub(/\s+$/, '') + "\n"
  end  
end
