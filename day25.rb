#!/usr/bin/ruby -w

$keys = []
$locks = []

$width = 5
$height = 6
    
this_shema = Array.new($width) { -1 }
first_line = true
type = nil
loop do
    this_line = gets
    if ! this_line
        ( type == :lock ? $locks : $keys ) << this_shema
        break
    end
    if first_line
        type = this_line.start_with?("#") ? :lock : :key
        first_line = false
    end
    if this_line == "\n"
        first_line = true 
        ( type == :lock ? $locks : $keys ) << this_shema
        this_shema = Array.new($width) { -1 }
        next
    end
    this_line.chomp!
    this_char_array = this_line.chars.map { |c| c == "#" ? 1 : 0 }     
    this_shema = this_shema.zip(this_char_array).map { |a,b| a + b }
end

puts "keys"
puts $keys.inspect
puts "locks"
puts $locks.inspect

puts $keys.map { |key| $locks.map { |lock| key.zip(lock).map { |a,b| a + b }.any? { |x| x >= $height } ? 0 : 1 }.sum }.sum 