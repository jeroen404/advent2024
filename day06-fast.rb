#!/usr/bin/ruby -w



$guard_chars = ['^', '>', 'v', '<']


$obstacles_x = {}
$obstacles_y = {}

$obstacle_mapping = {
    '^' => $obstacles_x,
    '>' => $obstacles_y,
    'v' => $obstacles_x,
    '<' => $obstacles_y
}

$collision_mapping = {
    '^' => 1,
    '>' => -1,
    'v' => -1,
    '<' => 1
}

$trail = {}

$guard_x = nil
$guard_y = nil
$guard_char = nil

$max_x = nil
$max_y = nil

# read from stdin
y=0
while line = gets
    line.chomp.chars.each_with_index do |c,x|
        if $guard_chars.include?(c) 
            $guard_x =  x
            $guard_y = y
            $guard_char = c
        elsif c == '#'
            ($obstacles_x[x] ||= []) << y
            ($obstacles_y[y] ||= []) << x            
        end
    end
    $max_x = line.length - 1 
    y += 1
end

$max_y = y


def next_obstacle(x,y,char)
    z = (char == '^' || char == 'v' ? y : x)
    u = (char == '^' || char == 'v' ? x : y)
    if $collision_mapping[char] == 1
        new_z = ($obstacle_mapping[char][u] || []).filter { |zz| zz < z }.max 
    else
        new_z = ($obstacle_mapping[char][u] || []).filter { |zz| zz > z }.min
    end
    if new_z == nil
        return nil
    end
    new_z += $collision_mapping[char]
    return (char == '^' || char == 'v' ? [x,new_z] : [new_z,y])
end

def turn(char)
    return $guard_chars[($guard_chars.index(char) + 1) % 4]
end

def add_trail(x,y,xx,yy)
    if x == xx
        if y < yy
            (y..yy).each do |yy|
                ($trail[[x,yy]] ||= []) << true
            end
        else
            (yy..y).each do |yy|
                ($trail[[x,yy]] ||= []) << true
            end
        end
    else
        if x < xx
            (x..xx).each do |xx|
                ($trail[[xx,y]] ||= []) << true
            end
        else
            (xx..x).each do |xx|
                ($trail[[xx,y]] ||= []) << true
            end
        end
    end
end

def loops?(build_trail=false)
    tortoise_x = $guard_x
    tortoise_y = $guard_y
    tortoise_char = $guard_char
    hare_x = $guard_x
    hare_y = $guard_y
    hare_char = $guard_char
    loop do
        tortoise_x,tortoise_y = next_obstacle(tortoise_x,tortoise_y,tortoise_char)
        tortoise_char = turn(tortoise_char)
        2.times do
            new_hare_x,new_hare_y= next_obstacle(hare_x,hare_y,hare_char)
            if new_hare_x == nil
                if build_trail
                    case hare_char
                    when '^'
                        new_hare_x = hare_x
                        new_hare_y = 0
                    when '>'
                        new_hare_x = $max_x
                        new_hare_y = hare_y
                    when 'v'
                        new_hare_x = hare_x
                        new_hare_y = $max_y
                    when '<'
                        new_hare_x = 0
                        new_hare_y = hare_y
                    end
                    add_trail(hare_x,hare_y,new_hare_x,new_hare_y)
                end

                return false
            end
            if build_trail
                add_trail(hare_x,hare_y,new_hare_x,new_hare_y)
            end
            hare_x = new_hare_x
            hare_y = new_hare_y
            hare_char  = turn(hare_char)
        end
        if tortoise_x == hare_x && tortoise_y == hare_y && tortoise_char == hare_char
            return true
        end
    end
end

loops?(true)
puts "Part 1: #{$trail.keys.length}"

nb_loops = 0
$trail.keys.each do |x,y|
    ($obstacles_x[x] ||= []) << y
    ($obstacles_y[y] ||= []) << x
    if loops?(false)
        nb_loops += 1
    end
    ($obstacles_x[x] ||= []).pop
    ($obstacles_y[y] ||= []).pop
end

puts "Part 2: #{nb_loops}"
    