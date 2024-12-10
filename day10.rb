#!/usr/bin/ruby -w

$world = []

$trail_heads = []
$valid_cache = {}


# read from stdin
y=0
while line = gets
    line_a = []
    line.chomp.chars.each_with_index do |c,x|
        if c == "0"
            $trail_heads << [x,y]
        end
        if c == "."
            c="-1"
        end
        line_a << c.to_i
    end
    $world << line_a
    y += 1
end

def inside?(x,y)
    return x >= 0 && y >= 0 && x < $world[0].length && y < $world.length
end

def neighbors(x,y)
    return [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].filter { |x,y| inside?(x,y) }
end

def valid_neighbors(x,y)
    return $valid_cache[[x,y]] ||= neighbors(x,y).filter { |xx,yy| $world[yy][xx] == $world[y][x] + 1 }
end

def peaks_reachable(x,y)
    if $world[y][x] == 9
        return [[x,y]]
    end
    return valid_neighbors(x,y).flat_map { |xx,yy| peaks_reachable(xx,yy) }.uniq
end

def print_world
    $world.each do |line|
        puts line.join('')
    end
end

puts $trail_heads.map { |x,y| peaks_reachable(x,y) }.map(&:length).inject(:+)
