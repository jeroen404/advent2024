#!/usr/bin/ruby -w

# input = ""
# # read from stdin
# while line = gets
#     input += line.chomp
# end

# mult_instr = input.scan(/mul\(\d{1,3},\d{1,3}\)/)

# puts mult_instr.map { |instr| instr.scan(/\d{1,3}/).map(&:to_i).inject(:*) }.inject(0, :+)

puts $stdin.read.scan(/mul\(\d{1,3},\d{1,3}\)/).map { |instr| instr.scan(/\d{1,3}/).map(&:to_i).inject(:*) }.inject(0, :+)

#$stdin.read.scan(/mul\(\d{1,3},\d{1,3}\)/).map { |instr| instr.scan(/\d{1,3}/).map(&:to_i).inject(:*) }.inject(0, :+)