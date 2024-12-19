#!/usr/bin/ruby -w

$towel_patterns = []
$designs = []

$cache_nb_matches = {}

def nb_matches(design)
    if $cache_nb_matches.has_key?(design)
        return $cache_nb_matches[design]
    end
    number = 0
    $towel_patterns.each do |pattern|
        if design.start_with?(pattern) 
            if pattern.length == design.length 
                number += 1
            else
                number += nb_matches(design[pattern.length..-1])
            end
        end
    end
    $cache_nb_matches[design] = number
    return number
end

# read from stdin
$towel_patterns = gets.chomp.split(', ')
gets # skip line
while line = gets
    $designs << line.chomp
end

# part 1
puts $designs.filter { |design| nb_matches(design) > 0 }.length
# part 2
puts $designs.map { |design| nb_matches(design) }.sum