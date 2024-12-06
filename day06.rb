#!/usr/bin/ruby -w

$world = []
guard_chars = ['^', '>', 'v', '<']
$movement_mapping = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0]
}
#obstacle_chars = ['#']
passible_chars = ['.', 'X']
$guard_x = nil
$guard_y = nil
$guard_char = nil

# read from stdin
while line = gets
    line_a = line.chomp.chars
    $world << line_a
    xx = line_a.index { |c| guard_chars.include?(c) }
    if xx
        $guard_x =  xx
        $guard_y = $world.length - 1
        $guard_char = $world[$guard_y][$guard_x]
        $world[$guard_y][$guard_x] = 'X'
    end
end

def inside?(x,y)
    return x >= 0 && y >= 0 && x < $world[0].length && y < $world.length
end

def next_move
    return $guard_x + $movement_mapping[$guard_char][0], $guard_y + $movement_mapping[$guard_char][1]
end

def print_world
    $world.each do |line|
        puts line.join('')
    end
end

loop do
    new_guard_x,new_guard_y = next_move
    if !inside?(new_guard_x,new_guard_y)
        break
    end
    if passible_chars.include?($world[new_guard_y][new_guard_x])
        $guard_x = new_guard_x
        $guard_y = new_guard_y
        $world[$guard_y][$guard_x] = 'X'
    else
        $guard_char = guard_chars[(guard_chars.index($guard_char) + 1) % 4]
    end
end

puts $world.flatten.count { |c| c == 'X' }