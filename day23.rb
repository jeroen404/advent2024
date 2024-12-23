#!/usr/bin/ruby -w

require 'set'

class Node < Struct.new(:name)
    def initialize(name)
        super(name)
        @neighbors = []
    end
    def add_neighbor(node)
        @neighbors << node
    end
    def neighbors
        return @neighbors
    end    
end

class Graph < Hash

    def connect(a,b)
        self[a].add_neighbor(b)
        self[b].add_neighbor(a)
    end
    def add_if_not_exists(name)
        self[name] ||= Node.new(name)
    end

    def all_direct_connected?(name,others)
        if self[name].neighbors.size < others.size
            return false
        end
        direct_ok = others.all? { |other| self[name].neighbors.include?(other) }
        if others.size == 1
            return direct_ok
        elsif direct_ok
            #return others.all? { |other| all_direct_connected?(other,others - [other]) } # uhm not so smart
            # see if intersection of neighbors of others with others is equal to others - 1
            return others.all? { |other| ((self[other].neighbors) & others).size == ((others.size) - 1) }
        else
            return false
        end
    end

    def direct_interconnects_at(name,size)
        direct_groups = []
        self[name].neighbors.combination(size - 1).each do |group|
            if all_direct_connected?(name,group)
                direct_groups << group
            end
        end
        return direct_groups
    end

    def all_direct_interconnects(size)
        groups = Set.new
        self.each do |name,node|
            next if node.neighbors.size < size - 1
            direct_interconnects_at(name,size).each do |group|
                groups << ([name] + group).sort  # sort to make it unique for Set
            end
        end
        return groups
    end

    def largest_direct_interconnect(start_size)
        largest = nil
        start_size.downto(2) do |size|
            largest = all_direct_interconnects(size)
            if largest.size > 0
                return largest
            end
        end
        return largest
    end
    # find a start size
    # doesn't save a lot of time
    def neighbors_max_size
        max = 0
        self.each do |name,node|
            max  = node.neighbors.size if node.neighbors.size > max
        end
        return max
    end
end

def has_node_starting_with(group,letter)
    return group.any? { |name| name.start_with?(letter) }
end

$graph = Graph.new()

# read from stdin
while line = gets
    a,b = line.chomp.split('-')
    $graph.add_if_not_exists(a)
    $graph.add_if_not_exists(b)
    $graph.connect(a,b)
end

# part 1
puts $graph.all_direct_interconnects(3).filter { |group| has_node_starting_with(group,"t") }.size

# part 2
max= $graph.neighbors_max_size
puts $graph.largest_direct_interconnect(max).join(",")

