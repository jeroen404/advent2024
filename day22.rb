#!/usr/bin/ruby -w

require 'set'

def mix(a,b)
    return a ^ b
end

def prune(a)
    return a % 16777216 # 2^24
    #return a & 0xFFFFFF
end

def next_secret(a)
    b = a * 64   # 2^6
    #b = a << 6
    a = mix(a,b)
    a = prune(a)

    c = a / 32  # 2^5
    #c = a >> 5
    a = mix(a,c)
    a = prune(a)

    d = a * 2048 # 2^11
    #d = a << 11
    a = mix(a,d)
    a = prune(a)

    return a
end

def part1(a,times)
    times.times do
        a = next_secret(a)
    end
    return a
end

numbers = []
#read from stdin
while line = gets
    numbers << line.to_i
end

#part 1
puts numbers.map { |n| part1(n,2000) }.inject(:+)

prices = []
numbers.each do |n|
    prices_for_this_monkey = []
    2000.times do
        n = next_secret(n)
        prices_for_this_monkey << n % 10
    end
    prices << prices_for_this_monkey
end

price_changes = []
numbers.length.times do |i|
    price_changes_for_this_monkey = []
    prices[i].each_cons(2) do |a,b|
        price_changes_for_this_monkey << b - a
    end
    price_changes << price_changes_for_this_monkey
end

four_previous_changes_price_hash = {}
sequences = Set.new
numbers.length.times do |i|
    price_changes[i].each_cons(4).each.with_index do |changes,j|
        four_previous_changes_price_hash[[i,changes]] ||= prices[i][j+4]
        sequences << changes
    end
end

def total_value_for_sequence(size,lookuphash,sequence)
    total = 0
    size.times do |i|
        if lookuphash[[i,sequence]]
            total += lookuphash[[i,sequence]]
        end
    end
    return total
end

puts "Calculating values for #{sequences.length} sequences"
calculated_values = {}
sequences.each do |fourchanges|
     if !calculated_values[fourchanges]
         calculated_values[fourchanges] = total_value_for_sequence(numbers.length,four_previous_changes_price_hash,fourchanges)
     end
 end
 
 #part 2
 puts calculated_values.values.max

