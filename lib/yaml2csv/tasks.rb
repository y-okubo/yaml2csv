require 'yaml2csv'

namespace :yaml2csv do
  desc "Convert a yaml into a csv file"
  task :yaml2csv do
    array = []
    data = File.read(ENV['INPUT'])
    hash = YAML.load(data)

    array.concat Yaml2csv::yaml2array(data)

    csv_output = CSV.generate('', {:force_quotes => true}) { |csv_writer|
      array.each do |row|
        csv_writer << row
      end
    }
        
    if !ENV['OUTPUT'].nil?
      File.open(ENV['OUTPUT'], 'w') {|f| f.write(csv_output) }
    else
      puts yaml_output
    end
  end

  desc "Convert a csv into a yaml file"
  task :csv2yaml do
    input = File.read(ENV['INPUT'])
    yaml_output = Yaml2csv::csv2data(input, {:value_colnum => 1}) do |key, path, strvalue|
      strvalue + "_ADDED222"
    end
    if !ENV['OUTPUT'].nil?
      File.open(ENV['OUTPUT'], 'w') {|f| f.write(yaml_output) }
    else
      puts yaml_output
    end
  end
end