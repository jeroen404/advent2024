#!/usr/bin/ruby -w

$part2 = true

def concat_n(a,b)
    #return (a.to_s + b.to_s).to_i # 1,5 seconds
    return b + (a * (10 ** ((Math.log10(b)+1).floor))) #1,0 seconds
end

class Calibration < Struct.new(:value, :numbers)

    def self.parse(line)
        value, numbers_s = line.split(':')
        numbers = numbers_s.split.map(&:to_i)
        return Calibration.new(value.to_i, numbers)
    end

    def self.possible2?(value, numbers,index,acc)
        if index == numbers.length
            return value == acc
        end
        if acc > value
            return false
        end
        return possible2?(value, numbers, index+1, acc + numbers[index]) \
               || possible2?(value, numbers, index+1, acc * numbers[index]) \
               || ( $part2 && possible2?(value, numbers, index+1, concat_n(acc, numbers[index])) )
    end
end

calibrations = []

# read from stdin
while line = gets
    calibrations << Calibration.parse(line.chomp)
end

puts calibrations.filter{ |calibration| Calibration.possible2?(calibration.value,calibration.numbers,1,calibration.numbers[0]) }.map(&:value).inject(0, :+)

