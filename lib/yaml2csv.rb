#!/usr/bin/ruby
require 'rubygems'
require 'yaml'
require 'csv'
require 'ya2yaml'

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
end
