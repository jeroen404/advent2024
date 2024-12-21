#!/usr/bin/ruby -w

require 'pqueue'

$world = []
$world_size_x = nil
$world_size_y = nil
$cheat_duration = 2

#$path_to_finish_cache = {}

$distance_cache = {}

class Path < Struct.new(:head,:cost,:parent)
    include Comparable  
    def <=>(other)
        return other.cost <=> self.cost # reverse order
    end

    def full_path
        path = []
        current = self
        while current
            path << current
            current = current.parent
        end
        return path
    end
end

class Place < Struct.new(:x,:y)
    def inside?
        return x >= 0 && y >= 0 && x < $world_size_x && y < $world_size_y
    end
    def neighbors
        return [Place.new(x+1,y),Place.new(x-1,y),Place.new(x,y+1),Place.new(x,y-1)].select { |place| place.inside? }
    end
    def neighbors_at(distance)
        neighbors_a = [self]
        while distance > 0
            neighbors_a = neighbors_a.flat_map { |neighbor| neighbor.neighbors }.filter { |neighbor| ! neighbors_a.include?(neighbor) }
            distance -= 1
        end
        neighbors_a.delete(self)
        return neighbors_a
    end
    def world_char
        return $world[y][x]
    end
    #override hash
    # def hash
    #     return y * $world_size_y + x # x must always be smaller than $world_size too
    # end
end

def shortest_path(start,finish)
    paths = PQueue.new([])
    start = Path.new(start,0,nil)
    paths.push(start)
    visited = {}
    loop do
        shortest = paths.pop
        if !shortest
            return nil
        end
        if shortest.head == finish
            return shortest
        end
        shortest.head.neighbors.each do |neighbor|
            if neighbor.world_char == '#' 
                    next
            end
            cost = shortest.cost + 1
            neighbor_path = Path.new(neighbor,cost,shortest)
            if !visited[neighbor]
                    paths.push(neighbor_path)
                    visited[neighbor] = true
            end
        end
    end
end

def update_distance_cache(path,total_cost)
    path.full_path.each do |subpath|
        $distance_cache[subpath.head] ||= total_cost - subpath.cost
    end
end

# read from stdin
while line = gets
    line_a = line.chomp.chars
    $world << line_a
    xx = line_a.index('S')
    if xx
        $start = Place.new(xx, $world.length - 1)
    end
    xx = line_a.index('E')
    if xx
        $finish = Place.new(xx, $world.length - 1)
    end
end
$world_size_y = $world.length
$world_size_x = $world[0].length

# puts Place.new(3,3).neighbors_at(2).inspect
# puts Place.new(3,3).neighbors_at(1).inspect

the_shortest_path = shortest_path($start,$finish)
#update_path_to_finish_cache(the_shortest_path)
update_distance_cache(the_shortest_path,the_shortest_path.cost)
total_no_cheat_distance = the_shortest_path.cost
puts "Distance without cheating: #{total_no_cheat_distance}"


cheats = {}

the_shortest_path.full_path.each do |path|
    path_distance = $distance_cache[path.head]
    path.head.neighbors_at($cheat_duration).each do |neighbor|
        next if $distance_cache[neighbor] == -1 || neighbor.world_char == '#'
        if ! $distance_cache[neighbor]    
            new_path = shortest_path(neighbor,$finish)
            if !new_path
                $distance_cache[neighbor] = -1
                next
            end
            update_distance_cache(new_path,new_path.cost)
        end
        cheat_distance_new_part = $distance_cache[neighbor] + 2
        cheat_distance_old_part = total_no_cheat_distance - path_distance
        cheat_distance = cheat_distance_new_part + cheat_distance_old_part
        if cheat_distance < total_no_cheat_distance
            #puts "Cheating from #{path.head.inspect} to #{neighbor.inspect} saves #{total_no_cheat_distance} - #{cheat_distance} = #{total_no_cheat_distance - cheat_distance}"
            cheats[[path.head,neighbor]] = total_no_cheat_distance - cheat_distance
        end
    end
end


#puts cheats.inspect
# puts cheats.values.min
# puts cheats.values.max
# puts cheats.values.tally.inspect

puts cheats.values.tally.filter { |k,v| k > 99 }.inject(0) { |sum,(k,v)| sum + v }
