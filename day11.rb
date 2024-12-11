#!/usr/bin/ruby -w

$stones = []
$stones = gets.chomp.split(' ').map(&:to_i)

$blink_cache = {}

$total_blinks = 75

def nb_digits(number)
    return Math.log10(number).to_i + 1
end

def split_number_in_two(number,nb_digits)
    right_ten_power = 10 ** (nb_digits / 2)
    left_half = number / right_ten_power
    right_half = number - left_half * right_ten_power # magic! or integer division :-)
    return left_half, right_half
end


def blink(number,blinks)
    if blinks == $total_blinks
        return 1
    end
    if $blink_cache[[number,blinks]]
        return $blink_cache[[number,blinks]]
    end
    if number == 0
        result = blink(1,blinks + 1)
        $blink_cache[[number,blinks]] = result
        return result
    else 
        nb_digits = nb_digits(number)
        if nb_digits.even?
            left_half, right_half = split_number_in_two(number,nb_digits)
            left_result = blink(left_half,blinks + 1)
            right_result = blink(right_half,blinks + 1)
            result = left_result + right_result
            $blink_cache[[number,blinks]] = result
            return result
        else
            result = blink(number * 2024,blinks + 1)
            $blink_cache[[number,blinks]] = result
            return result
        end
    end
end


puts $stones.map { |stone| blink(stone,0) }.inject(:+)

