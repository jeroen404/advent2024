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

    def next_instruction
        self.instruction_pointer = instruction_pointer + 1
    end

    def execute
        instruction = @programm[instruction_pointer]
        puts "#{@@instruction_set_names[instruction.op]} #{instruction.arg}" if $debug
        puts "#{register_a} #{register_b} #{register_c}" if $debug
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

computer.print_programm if $debug
#puts computer.run


