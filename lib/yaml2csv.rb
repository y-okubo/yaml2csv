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
  def self.yaml2array(yamldata, options = {:base_key => nil})
    if options[:base_key].nil?
      hash = YAML::load(yamldata)
    else
      hash = YAML::load(yamldata)[options[:base_key]]
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
  def self.csv2data(csvdata, options = {:header_added => false, :path_prefix => nil, :value_colnum => 1})
    walk_array = []

    CSV.parse(csvdata, {:headers => options[:header_added]}) do |row|
      if options[:path_prefix].nil?
        path = row[0].split(".")
      else
        path = [options[:path_prefix]].concat(row[0].split("."))
      end
      
      key = path.pop # destructive
      strvalue = row[options[:value_colnum].to_i].to_s

      if block_given?
        tmpvalue = yield(key, path, strvalue)
        strvalue = row[options[:value_colnum].to_i].to_s if tmpvalue.nil?
      end
      
      walk_array << [path.map(&:to_s), key.to_s, strvalue]
    end

    hash = Hash.unwalk_from_array(walk_array)
    data = hash.ya2yaml.gsub(/\s+$/, '') + "\n"
    data.sub(/^---\n/,'')
  end  
end
