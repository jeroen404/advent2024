#!/usr/bin/ruby -w

$part2 = true

class Antenna < Struct.new(:x, :y)
end

def distance(a,b)
    return (a-b).abs
end

def is_double_distance_x_y?(x,y,x1,y1,x2,y2)
    return distance(x,x1)==2*distance(x,x2) && distance(y,y1)==2*distance(y,y2) || distance(x,x2)==2*distance(x,x1) && distance(y,y2)==2*distance(y,y1)
end

def inline?(x,y,x1,y1,x2,y2)
    return (x-x1)*(y2-y1) == (y-y1)*(x2-x1)
end

$frequencies = {}

# read from stdin
y=0
while line = gets
    x=0
    line.chomp.chars.each do |c|
        if c != '.'
            ($frequencies[c] ||= []) << Antenna.new(x,y)
        end
        x+=1
    end
    y+=1
end

$max_x = x
$max_y = y
$anti_nodes = {}

(0..$max_y-1).each do |y|
    (0..$max_x-1).each do |x|
        $frequencies.each do |f,a|
            a.combination(2).each do |a1,a2|
                if inline?(x,y,a1.x,a1.y,a2.x,a2.y)                                 
                    if $part2 || is_double_distance_x_y?(x,y,a1.x,a1.y,a2.x,a2.y)
                        $anti_nodes[[x,y]] = true
                    end
                end
            end
        end
    end
end


puts $anti_nodes.length