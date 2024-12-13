#!/usr/bin/ruby -w

require 'set'

$regions = []
$world = []
$world_regions = {}


class Region < Struct.new(:plant_type,:id, :coords)
    
    def add(x,y)
        coords << [x,y] unless contains?(x,y)
    end

    def area
        return coords.length
    end

    def contains?(x,y)
        return coords.include?([x,y])
    end

    def outside_borders_for(x,y)
        return world_neighbours(x,y).filter { |xx,yy| outside_of_world?(xx,yy) || !contains?(xx,yy) }
    end

    def perimeter
        return coords.map { |x,y| outside_borders_for(x,y) }.map(&:length).inject(:+)
    end

    # gave up and looked at https://old.reddit.com/r/adventofcode/comments/1hcxmpp/2024_day_12_part_2_visualisation_of_my_first/
    def nb_sides
        if coords.length <= 2 # 1 or 2 points always have 4 corners
            return 4
        end
        count = 0
        left = {}
        right = {}
        min_x = coords.map { |x,y| x }.min
        max_x = coords.map { |x,y| x }.max
        min_y = coords.map { |x,y| y }.min
        max_y = coords.map { |x,y| y }.max
        (min_x..max_x).each do |x|
            (min_y..max_y).each do |y|
                if $world_regions[[y,x]] == self
                    if $world_regions[[y,x-1]] != self
                        (left[x] ||= []) << y
                    end
                    if $world_regions[[y,x+1]] != self
                        (right[x] ||= []) << y
                    end
                end
            end
        end
        left.keys.each do |x|
            count += 1          
            left[x].each_cons(2) do |a,b|
                count += 1 if b-a > 1
            end
        end
        right.keys.each do |x|
            count += 1
            right[x].each_cons(2) do |a,b|
                count += 1 if b-a > 1
            end
        end
        return count*2
    end

    def add_all_same(x,y)
        world_neighbours(x,y).each do |xx,yy|
            if ! outside_of_world?(xx,yy) && ! $world_regions[[yy,xx]] && $world[yy][xx] == plant_type
                $world_regions[[yy,xx]] = self
                add(xx,yy)
                add_all_same(xx,yy)
            end
        end
    end
            
end

def world_neighbours(x,y)
    return [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
end

def outside_of_world?(x,y)
    return x < 0 || y < 0 || x >= $world[0].length || y >= $world.length
end

while line_in = gets
    $world << line_in.chomp.chars
end

id=0
y=0
$world.each do |line|
    line.each_with_index do |plant_type,x|
        if ! $world_regions[[y,x]]
            $world_regions[[y,x]] = Region.new(plant_type, id, [[x,y]])
            $world_regions[[y,x]].add_all_same(x,y)
            $regions << $world_regions[[y,x]]
            id += 1
        end
    end
    y += 1
end
        
puts $regions.map { |region| region.area * region.perimeter }.inject(:+)

puts $regions.map { |region| region.area * region.nb_sides }.inject(:+)