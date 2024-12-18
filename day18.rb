#!/usr/bin/ruby -w


# gem install rbtree
require 'pqueue'

 $world_size = 71
 $bytes_per_step = 1024
# $world_size = 7
# $bytes_per_step = 12

$world = {}

$start = [0,0]
$finish = [$world_size-1,$world_size-1]

$bytes_strings = []

class Path < Struct.new(:head,:cost,:parent)
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

def inside?(place)
    #return x >= 0 && y >= 0 && x < $world_size && y < $world_size
    return place[0] >= 0 && place[1] >= 0 && place[0] < $world_size && place[1] < $world_size
end

def neighbors(place)
    x,y = place
    return [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].select { |x,y| inside?([x,y]) && ! $world[[x,y]] }
end

def shortest_path(start,finish)
    paths = PQueue.new([]) { |a, b| a.cost < b.cost }
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
        neighbors(shortest.head).each do |neighbor|
            cost = shortest.cost + 1
            if !visited[[neighbor]]
                    paths.push(Path.new(neighbor,cost,shortest))
                    visited[[neighbor]] = cost + 1
            end
        end
    end
end

def print_world
    $world_size.times do |y|
        $world_size.times do |x|
            print $world[[x,y]] ? '#' : '.'
        end
        puts
    end
end

#read from stdin
while line = gets
    $bytes_strings << line.chomp
end

$bytes_per_step.times do |i|
    x,y = $bytes_strings[i].split(',').map(&:to_i)
    $world[[x,y]] = 1
end

#print_world


shortest_path_found = shortest_path($start,$finish)
#part 1
puts shortest_path_found.cost
# all_coords = shortest_path_found.full_path
# $bytes_strings.slice($bytes_per_step..-1).each do |line|   
#     x,y = line.split(',').map(&:to_i)
#     $world[[x,y]] = 1
#     if all_coords.include?([x,y])
#         shortest_path_found = shortest_path($start,$finish)
#         if ! shortest_path_found
#             puts "found at #{x},#{y}"
#             break
#         end
#         all_coords = shortest_path_found.full_path
#     end
# end


$bytes = $bytes_strings.map { |line| line.split(',').map(&:to_i) }

start_range= $bytes_per_step
stop_range = $bytes_strings.length
loop do
    middle = (start_range + stop_range) / 2
    $bytes[0...middle].each do |x,y|
        $world[[x,y]] = 1
    end
    shortest_path_found = shortest_path($start,$finish)
    if shortest_path_found
        start_range = middle
    else
        stop_range = middle
    end
    $world = {}
    puts "start_range: #{start_range}, stop_range: #{stop_range}"
    break if stop_range - start_range < 2
end
puts $bytes[start_range].join(',')