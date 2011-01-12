require 'spec_helper'

EXAMPLE_HASH = {
  "a" => {
    "b" => 3,
    "c" => 5,
  },
  "d" => 7,
}
    
EXAMPLE_ARY = [
  [["a"], "b", 3], 
  [["a"], "c", 5], 
  [[], "d", 7],
]

describe Hash do
  it "should store paths" do
    {1 => 2, 3 => {4 => 5}}.should == {1 => 2}.merge_path([3, 4], 5)

    {1 => 2, 3 => {4 => 5, 5 => 50}}.should == {1 => 2, 3 => {5 => 50}}.merge_path([3, 4], 5)
  end

  it "should walk" do
    EXAMPLE_ARY.should == EXAMPLE_HASH.to_enum(:walk).to_a
  end

  it "should unwalk" do
    EXAMPLE_HASH.should == Hash.unwalk_from_array(EXAMPLE_ARY)
  end
end
