#!/usr/bin/ruby -w


class ComputerFile < Struct.new(:id)
end

class DataBlock < Struct.new(:file)
end

$disk = []

def compact_disk
    right_index = $disk.length - 1
    left_index = $disk.index { |block| block.file.nil? }
    while left_index < right_index
        if $disk[right_index].file.nil?
            right_index -= 1
        else
            $disk[left_index], $disk[right_index] = $disk[right_index], $disk[left_index]
            #left_index = $disk.index { |block| block.file.nil? }  # much slower
            while ! $disk[left_index].file.nil? && left_index < right_index
                left_index += 1
            end
            right_index -= 1
        end
    end
end

def checksum_disk
    checksum = 0
    $disk.each_with_index do |block, index|
        if ! block.file.nil?
            checksum += block.file.id * index
        end
    end
    return checksum
end

input = gets.chomp

current_id = 0
input.chars.each_slice(2) do |file_length,free_space|
    file_length = file_length.to_i
    free_space = free_space.to_i
    file = ComputerFile.new(current_id)
    
    $disk += [DataBlock.new(file)] * (file_length)
    $disk += [DataBlock.new(nil)] * free_space

    current_id += 1
end

compact_disk

puts checksum_disk