#!/usr/bin/ruby -w

$allwires = {}

#read from stdin
while line = gets
    if line == "\n"
        break
    end
    name,value_s = line.chomp.split(': ')
    value = value_s.to_i
    $allwires[name] = value == 1 ? -> { 1 } : -> { 0 }
end
while line = gets
    input1name,typename,input2name,outputname = line.match(/(.*) (.*) (.*) -> (.*)/).captures
    case typename
    when "AND"
       $allwires[outputname] = proc {|in1=input1name,in2=input2name| ->  {$allwires[in1].call & $allwires[in2].call}}.call
    when "OR"
        $allwires[outputname] = proc {|in1=input1name,in2=input2name| ->  { $allwires[in1].call | $allwires[in2].call}}.call
    when "XOR"
        $allwires[outputname] = proc {|in1=input1name,in2=input2name| ->  {$allwires[in1].call ^ $allwires[in2].call}}.call
    end
end

$z_wires = $allwires.keys.filter { |wirename| wirename.start_with?("z") }.sort
puts $z_wires.map { |wirename| $allwires[wirename].call }.each_with_index.inject(0) { |sum, (bit,i)| sum + bit * 2**i }
