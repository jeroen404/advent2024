#!/usr/bin/ruby -w

# gem install rbtree
require 'rbtree'

$world = []
$start = nil
$finish = nil

$cost_of_turn = 1000

$movements = ['^', '>', 'v', '<']
$movement_mapping = {
    '^' => [0, -1],
    '>' => [1, 0],
    'v' => [0, 1],
    '<' => [-1, 0]
}

class Path < Struct.new(:head,:direction,:cost)
    def <=>(other)
        return self.cost <=> other.cost
    end
end

def inside?(x,y)
    return x >= 0 && y >= 0 && x < $world[0].length && y < $world.length
end

def print_world
    $world.each do |line|
        puts line.join('')
    end
end

def neighbors_with_direction(place)
    $movement_mapping.each do |direction, movement|
        new_x = place[0] + movement[0]
        new_y = place[1] + movement[1]
        if inside?(new_x,new_y) && $world[new_y][new_x] != '#'
            yield [new_x,new_y],direction
        end
    end
end
    

def turning_cost(direction1,direction2)
    index1 = $movements.index(direction1)
    index2 = $movements.index(direction2)
    diff = (index1 - index2).abs 
    if diff == 3
        diff = 1
    end
    return diff * $cost_of_turn
end

def shortest_path(start,finish,start_direction)
    paths = MultiRBTree.new()
    start = Path.new(start,start_direction,0)
    paths[start] = true
    visited = {}
    loop do
        shortest = paths.first ?  paths.first[0] : nil
        if !shortest
            return nil
        end
        if shortest.head == finish
            return shortest
        end
        paths.delete(shortest)
        #visited[[shortest.head,shortest.direction]] = true
        visited[[shortest.head]] = true
        neighbors_with_direction(shortest.head) do |neighbor,neighbor_direction|
            cost = shortest.cost + turning_cost(shortest.direction,neighbor_direction) + 1
            #if !visited[[neighbor,neighbor_direction]]
            if !visited[[neighbor]]
                paths[Path.new(neighbor,neighbor_direction,cost)] = true
            end
        end
    end
end

def is_on_a_shortest_path(start,finish,start_direction,place,shortest_cost)
    if place == finish || place == start
        return true
    end
    path1 = shortest_path(start,place,start_direction)
    #puts "Place #{place} path1: #{path1.inspect}"
    path2 = shortest_path(place,finish,path1.direction)
    if !path1 || !path2
        return false
    end
    puts "Place #{place} path1: #{path1.cost} path2: #{path2.cost} shortest: #{shortest_cost}"
    return path1.cost + path2.cost == shortest_cost
end


while line = gets
    line_a = line.chomp.chars
    $world << line_a
    xx = line_a.index('S')
    if xx
        $start = [xx, $world.length - 1]
    end
    xx = line_a.index('E')
    if xx
        $finish = [xx, $world.length - 1]
    end
end

puts "Finish: #{$finish}"
#print_world

shortest = shortest_path($start,$finish,'>').cost

puts shortest

nb_seats = 0
(0...$world.length).each do |y|
    (0...$world[0].length).each do |x|
        if $world[y][x] != '#'
            if is_on_a_shortest_path($start,$finish,'>',[x,y],shortest)
                $world[y][x] = 'O'
                nb_seats += 1
            end
        end
    end
end
puts nb_seats