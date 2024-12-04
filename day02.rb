#!/usr/bin/ruby -w

reports = []

# read from stdin
while line = gets
    reports << line.split.map(&:to_i)
end

def distance(a,b)
    return (a-b).abs
end

def points_safe?(a,b)
    d=distance(a,b)
    return d<=3 && d>0
end

def report_safe?(report)
    report.each_cons(2).all? { |a,b| points_safe?(a,b) } && (report.each_cons(2).all? { |a,b| a<b } || report.each_cons(2).all? { |a,b| a>b })
end

puts reports.count { |report| report_safe?(report) }