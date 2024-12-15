#!/usr/bin/ruby -w

$part2 = true

$world = []
$robot_x = 0
$robot_y = 0

$moves =[]
$moves_index = 0

$movement_mapping = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0]
}

$part2_mapping = {
    '#' => ['#','#'],
    'O' => ['[',']'],
    '@' => ['@','.'],
    '.' => ['.','.'],
}

def is_possible_move?(x,y,direction)
    new_x = x + $movement_mapping[direction][0]
    new_y = y + $movement_mapping[direction][1]
    next_char = $world[new_y][new_x]
    if next_char == '#'
        return false
    elsif next_char == '.'
        return true
    elsif next_char == 'O' || ['<','>'].include?(direction)
        return is_possible_move?(new_x,new_y,direction)
    else
        left_x = next_char == '[' ? new_x : new_x - 1
        return is_possible_move?(left_x,new_y,direction) && is_possible_move?(left_x+1,new_y,direction)
    end
end

def shove(x,y,direction)
    new_x = x + $movement_mapping[direction][0]
    new_y = y + $movement_mapping[direction][1]
    next_char = $world[new_y][new_x]
    case next_char
    when 'O'
        shove(new_x,new_y,direction)
    when '['
        if ['^','v'].include?(direction)
            shove(new_x+1,new_y,direction)
        end
        shove(new_x,new_y,direction)
    when ']'
        if ['^','v'].include?(direction)
            shove(new_x-1,new_y,direction)
        end
        shove(new_x,new_y,direction)
    end
    $world[new_y][new_x] = $world[y][x]
    $world[y][x] = '.'
end

def print_world
    $world.each do |line|
        puts line.join
    end
end

while line = gets
    break if line == "\n"
    line_a = line.chomp.chars
    if $part2
        line_a = line_a.map { |c| $part2_mapping[c] }.flatten
    end
    $world << line_a
    xx = line_a.index('@')
    if xx
        $robot_x =  xx
        $robot_y = $world.length - 1
    end
end

while line = gets
    $moves += line.chomp.chars
end

$moves.each do |move|
    if is_possible_move?($robot_x,$robot_y,move)
        shove($robot_x,$robot_y,move)
        $robot_x += $movement_mapping[move][0]
        $robot_y += $movement_mapping[move][1]
    end
end

#print_world

gps_score = 0
(1..$world.length-2).each do |y|
    (1..$world[0].length-2).each do |x|
        if ['O','['].include?($world[y][x])
            gps_score += (100* y) + x
        end
    end
end

puts gps_score