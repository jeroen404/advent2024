#!/usr/bin/ruby -w

$disk = []

$file_start = {}
$file_size = {}


def checksum_disk
   return $disk.each_with_index.inject(0) { |sum, (block, index)| block.nil? ? sum : sum + block * index }
end

input = gets.chomp

current_id = 0
index = 0
input.chars.each_slice(2) do |file_length,free_space|
    file_length = file_length.to_i
    free_space = free_space.to_i

    $disk += Array.new(file_length) { current_id }
    $disk += Array.new(free_space) { nil }
    $file_start[current_id] = index
    $file_size[current_id] = file_length
    index += file_length + free_space
    current_id += 1
end

cache_start_place = {}

$file_start.reverse_each do |file_id,file_start|
    size = $file_size[file_id]
    left_index = cache_start_place[size] || 0
    while left_index < file_start
        if $disk[left_index...left_index+size].all? { |block| block.nil? }
            cache_start_place[size] = left_index + size
            (left_index...(left_index + size)).each { |i| $disk[i] = file_id }
            (file_start...(file_start + size)).each { |i| $disk[i] = nil }
            break
        end
        left_index += $file_size[$disk[left_index]] || 1
    end
end


puts checksum_disk