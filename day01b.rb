#!/usr/bin/ruby -w

list1 = []
list2 = []

# read from stdin
while line = gets
    n1, n2 = line.split.map(&:to_i)
    list1 << n1
    list2 << n2
end

puts list1.map { |n1| list2.count(n1) * n1 }.inject(0, :+)