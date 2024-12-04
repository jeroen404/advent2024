#!/usr/bin/ruby -w

input = ""
# read from stdin
while line = gets
    input += line.chomp
end

multi_regex = /mul\(\d{1,3},\d{1,3}\)/
multi_regex_capt = /mul\((\d{1,3}),(\d{1,3})\)/
do_regex = /do\(\)/
dont_regex = /don't\(\)/

do_instr = true
products = []
input.scan(Regexp.union(multi_regex, do_regex, dont_regex)) do |m|
    if m == "do()"
        do_instr = true
    elsif m == "don't()"
        do_instr = false
    else
        if do_instr
            instr = m
            #puts instr
            instr.match(multi_regex_capt) do |m|
                products << m[1].to_i * m[2].to_i
            end
        end
    end
end

puts products.inject(0, :+)