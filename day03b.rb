#!/usr/bin/ruby -w


puts $stdin.read.gsub(/don't\(\).*?do\(\)/m,'').scan(/mul\(\d{1,3},\d{1,3}\)/).map { |instr| instr.scan(/\d{1,3}/).map(&:to_i).inject(:*) }.inject(:+)

