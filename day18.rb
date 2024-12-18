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

    # def length
    #     return 1 + (self.parent ? self.parent.length : 0)
    # end
end

def inside?(place)
    #return x >= 0 && y >= 0 && x < $world_size && y < $world_size
    return place[0] >= 0 && place[1] >= 0 && place[0] < $world_size && place[1] < $world_size
end

def neighbors(place)
    x,y = place
    return [[x+1,y],[x-1,y],[x,y+1],[x,y-1]].select { |x,y| inside?([x,y]) }
end

def shortest_paths(start,finish)
    paths = PQueue.new([]) { |a, b| a[1] < b[1] }
    #start = Path.new(start,0,nil)
    paths.push([start, 0])
    visited = {}
    # shortest_distance = nil
    # all_shortest = []
    loop do
        shortest = paths.pop
        if !shortest
            return nil
        end
        if shortest[0] == finish
            return shortest[1]
            # if !shortest_distance 
            #     shortest_distance = shortest.cost
            # end
            # if shortest.cost == shortest_distance
            # all_shortest << shortest
            # end
        end
        #paths.delete(shortest)
        #visited[[shortest[0]]] = true
        #puts "visited=#{visited.keys.length}"
        # paths.delete(shortest[0])ch do |neighbor|
        neighbors(shortest[0]).each do |neighbor|
            #puts "checking neighbor #{neighbor.inspect}"
            cost = shortest[1] + 1
            if !visited[[neighbor]]
                visited[[neighbor]] = true
                if ! $world[neighbor] || $world[neighbor] > cost
                    #puts "from #{shortest.head} adding path to neighbor #{neighbor} cost=#{cost}"
                    #paths[Path.new(neighbor,cost,shortest)] = true
                    #paths[neighbor] = cost
                    paths.push([neighbor, cost])
                end
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

print_world



puts shortest_paths($start,$finish)

$bytes_strings.slice($bytes_per_step..-1).each do |line|
    x,y = line.split(',').map(&:to_i)
    $world[[x,y]] = 1
    if !shortest_paths($start,$finish)
        puts "found at #{x},#{y}"
        break
    end
end