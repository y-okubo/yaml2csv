require 'yaml2csv'

namespace :yaml2csv do
  desc "Convert a yaml into a csv file"
  task :yaml2csv do
    input = File.read(ENV['INPUT'])
    csv_output = Yaml2csv::yaml2csv(input)
    if !ENV['OUTPUT'].nil?
      File.open(ENV['OUTPUT'], 'w') {|f| f.write(csv_output) }
    else
      puts csv_output
    end
  end

  desc "Convert a csv into a yaml file"
  task :csv2yaml do
    input = File.read(ENV['INPUT'])
    yaml_output = Yaml2csv::csv2yaml(input)
    if !ENV['OUTPUT'].nil?
      File.open(ENV['OUTPUT'], 'w') {|f| f.write(yaml_output) }
    else
      puts yaml_output
    end
  end

  desc "Convert a yaml into a csv file"
  task :yaml2arry do
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
  task :csv2hash do
    input = File.read(ENV['INPUT'])
    yaml_output = Yaml2csv::csv2hash(input, 5, 'ja') do |key, path|
      key + "2"
    end
    if !ENV['OUTPUT'].nil?
      File.open(ENV['OUTPUT'], 'w') {|f| f.write(yaml_output.sub(/---\n/,'')) }
    else
      puts yaml_output
    end
  end
end