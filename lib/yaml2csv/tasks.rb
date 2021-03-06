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
end