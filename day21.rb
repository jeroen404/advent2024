#!/usr/bin/ruby -w

class Coord < Struct.new(:x,:y)
end

class KeyPad
    @layout = []
    @start = nil

    def initialize(layout,start)
        @layout = layout
        @start = start
        if key_at(@start) != 'A'
            raise "Invalid start position"
        end
        @key_index = {}
        @layout.each_with_index do |line,y|
            line.each_with_index do |key,x|
                    @key_index[key] = Coord.new(x,y)
            end
        end
        #@cache_best = {}
        @cache_layered = {}
    end
    def key_at(coord)
        return @layout[coord.y][coord.x]
    end
    def inside?(coord)
        return coord.x >= 0 && coord.y >= 0 && coord.x < @layout[0].length && coord.y < @layout.length
    end

 
    def best_routes(start_key,stop_key)
        # if @cache_best[[start_key,stop_key]]
        #     return @cache_best[[start_key,stop_key]]
        # end
        start_pos,stop_pos = @key_index[start_key],@key_index[stop_key]
        ydiff = (stop_pos.y - start_pos.y).abs
        xdiff = (stop_pos.x - start_pos.x).abs
        hor_key = stop_pos.x > start_pos.x ? '>' : '<'
        ver_key = stop_pos.y > start_pos.y ? 'v' : '^'
        best_paths = []
        if key_at(Coord.new(stop_pos.x,start_pos.y)) != ' ' && ydiff > 0
            best_paths << hor_key * xdiff + ver_key * ydiff + 'A'
        end
        if key_at(Coord.new(start_pos.x,stop_pos.y)) != ' ' && xdiff > 0
            best_paths << ver_key * ydiff + hor_key * xdiff + 'A' 
        end
        if ydiff == 0 && xdiff == 0
            best_paths << 'A'
        end
        # @cache_best[[start_key,stop_key]] = best_paths
        return best_paths
    end

    def best_routes_keys(keys)
        ways = []
        current = key_at(@start)
        keys.chars.each_with_index do |key,index|
            paths = best_routes(current,key)
            ways[index] = paths
            current = key
        end
        # cartesian product with self for all ways 
        #all_ways = ways[0].product(*ways[1..-1]).map { |way| way.join } 
        # on second thought, we don't need to join the ways, makes it harder       
        return ways
    end

    def complexity(keys,layer,layers)
        return keys.length if layer == 0
        return @cache_layered[[keys,layer]] if @cache_layered[[keys,layer]]

        path_options = layers[layer].best_routes_keys(keys)
        total = 0
        path_options.each do |key_options|
            total += key_options.map { |key_option| complexity(key_option,layer-1,layers) }.min
        end
        @cache_layered[[keys,layer]] = total
        return total
    end
end

class NumericKeyPad < KeyPad
    def initialize
        layout = [
            ['7','8','9'],
            ['4','5','6'],
            ['1','2','3'],
            [' ','0','A']
        ]
        start = Coord.new(2,3)
        super(layout,start)
    end
end

class DirectionKeyPad < KeyPad
    def initialize
        layout = [
            [' ','^','A'],
            ['<','v','>'],
        ]
        start = Coord.new(2,0)
        super(layout,start)
    end
    def self.numerval(sequence)
        return sequence.scan(/\d+/)[0].to_i
    end
end

$num = NumericKeyPad.new
$mov = DirectionKeyPad.new

def solve(seq,nblayers)
    numval = DirectionKeyPad.numerval(seq)
    layers = Array.new(nblayers,$mov)
    layers.append($num)
    movval = $num.complexity(seq,nblayers,layers)  
   #puts "#{seq} Numval: #{numval} Movval: #{movval}"
   return numval * movval
end

seqs = []
#read from stdin
while line = gets
    seqs << line.chomp
end
# you count as a robot, so you need to add 1 to the number of layers
puts seqs.map { |seq| solve(seq,3) }.inject(0,:+)
puts seqs.map { |seq| solve(seq,26) }.inject(0,:+)

