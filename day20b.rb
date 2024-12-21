#!/usr/bin/ruby -w

require 'pqueue'

$world = []
$world_size_x = nil
$world_size_y = nil
$cheat_duration = 20

$min_saved_time = 100

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
    def walk_distance_to(other)
        return (self.x - other.x).abs + (self.y - other.y).abs
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


the_shortest_path = shortest_path($start,$finish)
update_distance_cache(the_shortest_path,the_shortest_path.cost)
total_no_cheat_distance = the_shortest_path.cost
puts "Distance without cheating: #{total_no_cheat_distance}"


cheats = {}

the_full_path = the_shortest_path.full_path.map { |path| path.head }.reverse
the_full_path.each_with_index do |place,index|
    start_index = index+$min_saved_time-1
    if start_index >= the_full_path.length
        break
    end
    the_full_path[start_index..-1].filter { |p| p.walk_distance_to(place) <= $cheat_duration }.each do |end_place|
        end_distance = $distance_cache[end_place]
        place_distance = $distance_cache[place]
        if end_distance + $cheat_duration < place_distance
            cheat_distance = place.walk_distance_to(end_place)
            saved_time = place_distance - (end_distance + cheat_distance)
            cheats[[place,end_place]] ||= saved_time
        end
    end
end

# slower, pfft
# the_full_path = the_shortest_path.full_path.map { |path| path.head }.reverse
# the_full_path.each do |place|
#     place_distance = $distance_cache[place]
#     min_x = [place.x - $cheat_duration,0].max
#     max_x = [place.x + $cheat_duration,$world_size_x-1].min
#     min_y = [place.y - $cheat_duration,0].max
#     max_y = [place.y + $cheat_duration,$world_size_y-1].min
#     (min_x..max_x).each do |x|
#         (min_y..max_y).each do |y|
#             check_place = Place.new(x,y)
#             cheat_distance = place.walk_distance_to(check_place)
#             #puts "Checking #{place.inspect} to #{check_place.inspect} (distance #{cheat_distance})"
#             if cheat_distance <= $cheat_duration
#                 check_distance = $distance_cache[check_place]
#                 if check_distance !=nil && check_distance + $cheat_duration < place_distance
#                     saved_time = place_distance - (check_distance + cheat_distance)
#                     cheats[[place,check_place]] ||= saved_time
#                 end
#             end
#         end
#     end
# end

#puts cheats.inspect

#puts cheats.values.tally.inspect

puts cheats.values.tally.filter { |k,v| k >= $min_saved_time }.inject(0) { |sum,(k,v)| sum + v }
