#!/usr/bin/ruby -w

list1 = []
list2 = []

# read from stdin
while line = gets
    n1, n2 = line.split.map(&:to_i)
    list1 << n1
    list2 << n2
end

list1.sort!
list2.sort!

def distance(a,b)
    return (a-b).abs
end

def sum_distance(list1, list2)
    list1.zip(list2).inject(0) { |sum, (a, b)| sum + distance(a, b) }
end

puts sum_distance(list1, list2)