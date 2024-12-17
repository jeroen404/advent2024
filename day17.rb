#!/usr/bin/ruby -w

$debug = true

class Computer < Struct.new(:register_a, :register_b, :register_c, :instruction_pointer)
    @@instruction_set = [
        #adv 
        lambda { |comp,arg| comp.register_a = comp.register_a / 2** comp.get_combo_arg(arg) ; comp.next_instruction },
        #bxl
        lambda { |comp,arg| comp.register_b = comp.register_b ^ arg ; comp.next_instruction },
        #bst
        lambda { |comp,arg| comp.register_b = comp.get_combo_arg(arg) % 8 ; comp.next_instruction },
        #jnz
        lambda { |comp,arg| if comp.register_a == 0 then comp.next_instruction else comp.instruction_pointer = arg end },
        #bxc
        lambda { |comp,arg| comp.register_b = comp.register_b ^ comp.register_c ; comp.next_instruction },
        #out
        lambda { |comp,arg| comp.output((comp.get_combo_arg(arg)%8).to_s) ; comp.next_instruction },
        #bdv
        lambda { |comp,arg| comp.register_b = comp.register_a / 2** comp.get_combo_arg(arg) ; comp.next_instruction },
        #cdv
        lambda { |comp,arg| comp.register_c = comp.register_a / 2** comp.get_combo_arg(arg) ; comp.next_instruction },
    ]
    @@instruction_set_names = ['adv','bxl','bst','jnz','bxc','out','bdv','cdv']
    
    @output_string = nil

    def initialize(register_a, register_b, register_c, programm_code)
        @programm = programm_code.split(',').each_slice(2).map { |op,arg| Instruction.new(op.to_i,arg.to_i) }
        super(register_a, register_b, register_c, 0)
    end

    def get_combo_arg(arg)
        case arg
            when 0,1,2,3
                return arg
            when 4
                return register_a
            when 5
                return register_b
            when 6
                return register_c
            when 7
                throw "Invalid combo argument"
        end
    end

    def output(string)
        @output_string = @output_string ? "#{@output_string},#{string}" : string
    end

    def reset
        self.register_a = 0
        self.register_b = 0
        self.register_c = 0
        self.instruction_pointer = 0
        @output_string = nil
    end

    def next_instruction
        self.instruction_pointer = instruction_pointer + 1
    end

    def execute
        instruction = @programm[instruction_pointer]
        #puts "#{@@instruction_set_names[instruction.op]} #{instruction.arg}" if $debug
        #puts "A #{register_a} B #{register_b} C #{register_c}" if $debug
        @@instruction_set[instruction.op].call(self,instruction.arg) 
    end

    def run
        while instruction_pointer < @programm.length
            execute
        end
        return @output_string
    end

    def print_programm
        @programm.each do |instruction|
            puts "#{@@instruction_set_names[instruction.op]} #{instruction.arg}"
        end
    end
end

class Instruction < Struct.new(:op, :arg)
end


def read_number
    return gets.gsub(/\D/,'').to_i
end

a,b,c = read_number, read_number, read_number
gets #spacer
code = gets.chomp.sub(/Program: /,'')
computer = Computer.new(a,b,c,code)

# part1
puts computer.run 

computer.print_programm if $debug
# part2
# bst 4   b = a mod 8
# bxl 1   b = b xor 1
# cdv 5   c = a / 2^b
# bxl 5   b = b xor 5
# bxc 3   b = b xor c
# adv 3   a = a / 2^3
# out 5   ouput b mod 8
# jnz 0   until a == 0

# b = (a mod 8) xor 1
# c = a >> b
# output (b xor 5 xor c) mod 8
# a = a >> 3
# until a == 0

needed_output = code.split(',').reverse

correct_so_far = [0]
needed_output.each_with_index do |needed_number,index|
    new_correct = []
    correct_so_far.each do |correct|
        (0..7).each do |digit_a|
            try_number = (correct << 3 ) + digit_a
            computer.reset
            computer.register_a = try_number 
            total_output = computer.run
            output = total_output.split(',').first.to_i
            if output == needed_number.to_i
                new_correct << try_number
            end
        end
    end
    correct_so_far = new_correct
end

puts correct_so_far.min


