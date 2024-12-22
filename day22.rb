#!/usr/bin/ruby -w

def prune_mix(a,b)
    return (a ^ b) % 16777216
end

def next_secret(a)
    a = prune_mix(a,a * 64)
    a = prune_mix(a,a / 32)
    a = prune_mix(a,a * 2048)
    return a
end

numbers = []
#read from stdin
while line = gets
    numbers << line.to_i
end

#part 1
puts numbers.map { |n| 2000.times.inject(n) { |a| next_secret(a) } }.sum

prices = numbers.map { |n| Array.new(2000) { n = next_secret(n); n % 10 } }

sequence_price_hash = Hash.new(0)

prices.each do |monkey_prices|
    sequences_for_this_monkey = {}
    monkey_prices.each_cons(2).map { |a, b| b - a}.each_cons(4).with_index do |changes,j|
        unless sequences_for_this_monkey.has_key?(changes)
            sequence_price_hash[changes] += monkey_prices[j+4]
            sequences_for_this_monkey[changes] = true
        end
    end
end
puts sequence_price_hash.values.max

