require 'spec_helper'

YAML_EXAMPLE =<<-EOF
---
path1:
  path11:
    key11a: value11a
    key11b: value11b
  path12:
    path121:
      key121a: value121a
path2:
  key2a: value2a
EOF

CSV_EXAMPLE = <<-EOF
path1/path11,key11a,value11a
path1/path11,key11b,value11b
path1/path12/path121,key121a,value121a
path2,key2a,value2a
EOF

describe Yaml2csv do

  it "should convert yaml to csv" do
    Yaml2csv::yaml2csv(YAML_EXAMPLE).should == CSV_EXAMPLE
  end

  it "should convert csv to yaml" do
    Yaml2csv::csv2yaml(CSV_EXAMPLE).should == YAML_EXAMPLE
  end

end
