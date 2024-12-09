#!/usr/bin/ruby -w


class ComputerFile < Struct.new(:id, :size, :next, :prev)
 
    def initialize(id, size)
        super(id, size, nil, nil)
    end

    def to_s
        s = id.nil? ? "." : id
        return "#{s}(#{size })"
    end
end

class Disk 
    include Enumerable

    @head = nil
    @tail = nil

    def append(file)
        if @head.nil?
            @head = file
            @tail = file
        else
            @tail.next = file
            file.prev = @tail
            @tail = file
        end
    end

    def each
        current = @head
        while !current.nil?
            yield current
            current = current.next
        end
    end

    def to_s
        self.each do |file|
            print file.to_s
        end
    end

    def insert_after(file, new_file)
        new_file.next = file.next
        new_file.prev = file
        file.next = new_file
        if new_file.next.nil?
            @tail = new_file
        else
            new_file.next.prev = new_file
        end
    end


    def move(empty_file, file)
        left_over = empty_file.size - file.size
        if left_over > 0
            new_empty_file_leftover = ComputerFile.new(nil, left_over)
            insert_after(empty_file, new_empty_file_leftover)
            empty_file.size = file.size
            move(empty_file, file)
        else
            swap(empty_file, file)
        end
    end


    def swap(file1, file2)
           
        if file1.next == file2  # Adjacent nodes fixed by chatgpt
            # Adjust head and tail if necessary
            @head = file2 if file1.prev.nil?
            @tail = file1 if file2.next.nil?
    
            # Update file1 and file2 links
            file1.next = file2.next
            file2.prev = file1.prev
    
            # Update surrounding nodes
            file2.next.prev = file1 unless file2.next.nil?
            file1.prev.next = file2 unless file1.prev.nil?
    
            # Finalize the direct connection
            file2.next = file1
            file1.prev = file2
        else
            # Non-adjacent nodes (general case)
            if file1.prev.nil?
                @head = file2
            else
                file1.prev.next = file2
            end
            if file2.next.nil?
                @tail = file1
            else
                file2.next.prev = file1
            end
    
            # Swap their neighbors
            file1.next.prev = file2
            file2.prev.next = file1
    
            # Swap file1 and file2 pointers
            file1.prev, file2.prev = file2.prev, file1.prev
            file1.next, file2.next = file2.next, file1.next
        end
    end
    
    def defragment 
        right_pointer = @tail
        while right_pointer != @head do 
            while right_pointer != @head && right_pointer.id.nil? do
                right_pointer = right_pointer.prev
            end
            left_pointer = @head
            while left_pointer != right_pointer && ! ( left_pointer.id.nil? && left_pointer.size >= right_pointer.size) do
                    left_pointer = left_pointer.next
            end
            orig_right_pointer_prev = right_pointer.prev
            if left_pointer != right_pointer
                move(left_pointer, right_pointer)
            end
            right_pointer = orig_right_pointer_prev
        end
    end

    def checksum
        checksum = 0
        current = @head
        index = 0
        while !current.nil?
            if ! current.id.nil?
                (index..index+current.size-1).each do |i|
                    checksum += current.id * i
                end
            end
            index += current.size
            current = current.next
        end
        return checksum
    end
    
end

$disk = Disk.new

puts "Starting disk processing"
input = gets.chomp

current_id = 0
input.chars.each_slice(2) do |file_length,free_space|
    file_length = file_length.to_i
    free_space = free_space.to_i
    file = ComputerFile.new(current_id, file_length)
    $disk.append(file)
    if free_space > 0
        file = ComputerFile.new(nil, free_space)
        $disk.append(file)
    end
    current_id += 1
end

puts "Disk read"
$disk.defragment
puts "Disk defragmented"

puts $disk.checksum