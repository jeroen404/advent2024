#!/usr/bin/ruby -w

$part2 = true

class Button < Struct.new(:x,:y)
    def self.parse(line)
        x,y = line.match(/Button [AB]: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
        return Button.new(x,y)
    end
end

class Prize < Struct.new(:x,:y)
    def self.parse(line)
        x,y = line.match(/Prize: X=(\d+), Y=(\d+)/).captures.map(&:to_i)
        return Prize.new(x,y)
    end
end

class ClawMachine < Struct.new(:buttonA,:buttonB,:prize)
    def determinant
        return (buttonA.x * buttonB.y) - (buttonA.y * buttonB.x)
    end

    def solve
        det = determinant
        a = (prize.x * buttonB.y - prize.y * buttonB.x) / det
        b = (prize.y * buttonA.x - prize.x * buttonA.y) / det
        #b = (prize.x - a * buttonA.x) / buttonB.x  # both work
        return a,b
    end 

    def valid?(a,b)
        return a*buttonA.x + b*buttonB.x == prize.x && a*buttonA.y + b*buttonB.y == prize.y
    end

    def token_cost
        a,b = solve
        return valid?(a,b) ? 3*a + b : 0
    end
end

$clawmachines = []

loop do
    buttonA = Button.parse(gets.chomp)
    buttonB = Button.parse(gets.chomp)
    prize = Prize.parse(gets.chomp)
    if $part2
        prize.x = prize.x + 10000000000000
        prize.y = prize.y + 10000000000000
    end
    $clawmachines << ClawMachine.new(buttonA,buttonB,prize)
    break if gets.nil?
end

puts $clawmachines.map(&:token_cost).inject(:+)