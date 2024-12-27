#!/usr/bin/ruby -w

class Gate < Struct.new(:input1,:input2,:output)
    def self.factory(input1, input2, output, type)
        case type
        when "AND"
            return AndGate.new(input1, input2, output)
        when "OR"
            return OrGate.new(input1, input2, output)
        when "XOR"
            return XorGate.new(input1, input2, output)
        end
    end
    def ishot?
        return output.value != nil
    end
    def isready?
        return input1.ishot? && input2.ishot?
    end
    def fire
        puts "#{input1.name}:#{input1.value} #{self.class} #{input2.name}:#{input2.value} -> #{output.name}:#{output.value}"
    end
end

class AndGate < Gate
    def fire
        output.value = input1.value & input2.value
        super
    end
end
class OrGate < Gate
    def fire
        output.value = input1.value | input2.value
        super
    end
end
class XorGate < Gate
    def fire
        output.value = input1.value ^ input2.value
        super
    end
end
class Wire < Struct.new(:name,:value)
    def self.parseline(input)
        name,value = input.split(': ')
        return Wire.new(name, value.to_i)
    end
    def ishot?
        return value != nil
    end
end

def bitarray_to_int(bitarray)
    return bitarray.reverse.each_with_index.inject(0) { |sum, (bit, i)| sum + bit * 2**i }
end

def debug_get_gate_with_inputs(name1,name2,array)
    return array.find { |gate| gate.input1.name == name1 && gate.input2.name == name2 }
end

#$allwires = {}
$allwires = {}
$x_wires = []
$y_wires = []
$z_wires = []
$cold_gates = []

#read from stdin
while line = gets
    if line == "\n"
        break
    end
    wire = Wire.parseline(line.chomp)
    $allwires[wire.name] = wire
end
while line = gets
    input1name,typename,input2name,outputname = line.match(/(.*) (.*) (.*) -> (.*)/).captures
    $allwires[input1name] ||= Wire.new(input1name,nil)
    $allwires[input2name] ||= Wire.new(input2name,nil)
    $allwires[outputname] ||= Wire.new(outputname,nil)
    input1 = $allwires[input1name]
    input2 = $allwires[input2name]
    output = $allwires[outputname]
    [input1,input2,output].each do |wire|
        $x_wires << wire if wire.name.start_with?("x")
        $y_wires << wire if wire.name.start_with?("y")
        $z_wires << wire if wire.name.start_with?("z")
    end
    $cold_gates << Gate.factory(input1, input2, output, typename)
end

$x_wires.sort_by! { |wire| wire.name }.reverse!
$y_wires.sort_by! { |wire| wire.name }.reverse!
$z_wires.sort_by! { |wire| wire.name }.reverse!

while ($z_wires.any? { |wire| !wire.ishot? } ) && ($cold_gates.any? { |gate| gate.isready? })
    $cold_gates.each do |gate|
        if gate.isready?
            gate.fire
            $cold_gates.delete(gate)
        end
    end
end

puts bitarray_to_int($z_wires.map { |wire| wire.value })