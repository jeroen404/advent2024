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

class Path < Struct.new(:head,:direction,:cost,:parent)
    include Comparable  
    def <=>(other)
        return self.cost <=> other.cost
    end
    def full_path
        path = []
        current = self
        while current
            path << current.head
            current = current.parent
        end
        return path
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

def shortest_paths(start,finish,start_direction)
    paths = MultiRBTree.new()
    start = Path.new(start,start_direction,0,nil)
    paths[start] = true
    visited = {}
    all_shortest = []
    shortest_distance = nil
    loop do
        shortest = paths.first ?  paths.first[0] : nil
        if !shortest
            return nil
        end
        if shortest_distance && shortest.cost > shortest_distance
            return all_shortest
        end
        if shortest.head == finish
            if !shortest_distance 
                shortest_distance = shortest.cost
            end
            if shortest.cost == shortest_distance
            all_shortest << shortest
            end
        end
        paths.delete(shortest)
        visited[[shortest.head,shortest.direction]] = true
        #visited[[shortest.head]] = true
        neighbors_with_direction(shortest.head) do |neighbor,neighbor_direction|
            cost = shortest.cost + turning_cost(shortest.direction,neighbor_direction) + 1
            if !visited[[neighbor,neighbor_direction]]
            #if !visited[[neighbor]]
                paths[Path.new(neighbor,neighbor_direction,cost,shortest)] = true
            end
        end
    end
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

shortest_paths = shortest_paths($start,$finish,'>')
shortest = shortest_paths[0].cost

nb_seats = shortest_paths.flat_map { |path| path.full_path }.uniq.length

puts shortest
puts nb_seats

