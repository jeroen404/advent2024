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

puts "..."
sequence_price_hash = Hash.new(0)
#sequences = Set.new
numbers.length.times do |i|
    sequences_for_this_monkey = {}
    price_changes[i].each_cons(4).each.with_index do |changes,j|
        if !sequences_for_this_monkey[changes]
            sequence_price_hash[changes] += prices[i][j+4]
            sequences_for_this_monkey[changes] = true
            #sequences << changes
        end

    end
end
puts sequence_price_hash.values.max

