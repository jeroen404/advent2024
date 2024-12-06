#!/usr/bin/ruby -w

$world = []
$guard_chars = ['^', '>', 'v', '<']
$movement_mapping = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0]
}

$guard_start_x = nil
$guard_start_y = nil
$guard_start_char = nil

# read from stdin
while line = gets
    line_a = line.chomp.chars
    $world << line_a
    xx = line_a.index { |c| $guard_chars.include?(c) }
    if xx
        $guard_start_x =  xx
        $guard_start_y = $world.length - 1
        $guard_start_char = $world[$guard_start_y][$guard_start_x]
        $world[$guard_start_y][$guard_start_x] = '.'
    end
end

def inside?(x,y)
    return x >= 0 && y >= 0 && x < $world[0].length && y < $world.length
end

def next_move(x,y,char)
    return x + $movement_mapping[char][0], y + $movement_mapping[char][1]
end

def loops?
    loops = false
    guard_x = $guard_start_x
    guard_y = $guard_start_y
    guard_char = $guard_start_char
    trail = {}
    loop do
        new_guard_x,new_guard_y = next_move(guard_x,guard_y,guard_char)
        if !inside?(new_guard_x,new_guard_y)
            break
        end
        if trail[[new_guard_x,new_guard_y]] && trail[[new_guard_x,new_guard_y]].include?(guard_char)
            loops = true
            break
        end 
        if $world[new_guard_y][new_guard_x] == '.'
            guard_x = new_guard_x
            guard_y = new_guard_y
            (trail[[guard_x,guard_y]] ||= []) << guard_char
        else
            guard_char = $guard_chars[($guard_chars.index(guard_char) + 1) % 4]
        end
    end
    return loops,trail
end

#only check where the guard walks
trail = loops?[1]
nb_loops = 0
trail.keys.each do |x,y|
        $world[y][x] = '#'
        if loops?[0]
            nb_loops += 1
        end
        $world[y][x] = '.'
end

puts nb_loops
           