#!/usr/bin/ruby -w

$allwires = {}
$type_mapping = { "AND" => "&","OR" => "|","XOR" => "^",}

#read from stdin
while line = gets
    break if line == "\n"
    name,value = line.chomp.split(': ')
    $allwires[name] = value == "1" ? -> { 1 } : -> { 0 }
end
while line = gets
    input1name,typename,input2name,outputname = line.match(/(.*) (.*) (.*) -> (.*)/).captures
    $allwires[outputname] = proc {|in1, in2, op| -> { $allwires[in1].call.send(op, $allwires[in2].call) }}.call(input1name, input2name, $type_mapping[typename])
end

$z_wires = $allwires.keys.filter { |wirename| wirename.start_with?("z") }.sort
puts $z_wires.map { |wirename| $allwires[wirename].call }.each_with_index.inject(0) { |sum, (bit,i)| sum + bit * 2**i }
