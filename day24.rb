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

$x_wires = $allwires.keys.filter { |wirename| wirename.start_with?("x") }.sort
$y_wires = $allwires.keys.filter { |wirename| wirename.start_with?("y") }.sort
$z_wires = $allwires.keys.filter { |wirename| wirename.start_with?("z") }.sort
#part 1
puts $z_wires.map { |wirename| $allwires[wirename].call }.each_with_index.inject(0) { |sum, (bit,i)| sum + bit * 2**i }




def swap(x,y)
    $allwires[x], $allwires[y] = $allwires[y], $allwires[x]
end
def array_to_int(array)
    return array.map { |wirename| $allwires[wirename].call }.each_with_index.inject(0) { |sum, (bit, i)| sum + bit * 2**i }
end

# christmas magic
swap("gjc", "qjj")
swap("wmp", "z17")
swap("z26","gvm")
swap("qsb","z39")

puts array_to_int($z_wires)

target_sum = array_to_int($x_wires) + array_to_int($y_wires)
puts target_sum