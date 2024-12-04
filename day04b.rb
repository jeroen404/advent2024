#!/usr/bin/ruby -w

input = []
# read from stdin
while line = gets
     input << line.chomp.chars
end


count = 0
(1..input.length-2).each do |y|
    (1..input[0].length-2).each do |x|
        if input[y][x] == "A"
            leg1_ok = (input[y-1][x-1] == "M" && input[y+1][x+1] == "S") || (input[y-1][x-1] == "S" && input[y+1][x+1] == "M")
            leg2_ok = (input[y+1][x-1] == "M" && input[y-1][x+1] == "S") || (input[y+1][x-1] == "S" && input[y-1][x+1] == "M")
            if leg1_ok && leg2_ok
                count += 1
            end
        end
    end
end

puts count