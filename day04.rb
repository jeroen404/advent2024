#!/usr/bin/ruby -w

input = []
# read from stdin
while line = gets
     input << line.chomp.chars
end

$search_string = "XMAS"

def neighbours(x,y,max_x,max_y)
    return [[x-1,y-1],[x+1,y-1],[x-1,y+1],[x+1,y+1],[x-1,y],[x+1,y],[x,y-1],[x,y+1],].select { |x,y| x >= 0 && x < max_x && y >= 0 && y < max_y }
end

def neighbour(x,y,dx,dy,max_x,max_y)
    nx = x + dx
    ny = y + dy
    if nx >= 0 && nx < max_x && ny >= 0 && ny < max_y
        return [nx,ny]
    end
    return nil
end

def search_direction(x,y,dx,dy,grid,word)
    matches = 0
    if grid[y][x] == word[0]
        if word.length == 1
            return 1
        end
        nx,ny = neighbour(x,y,dx,dy,grid[0].length,grid.length)
        if nx != nil
            matches += search_direction(nx,ny,dx,dy,grid,word[1..-1])
        end
    end
    return matches
end

def start_search(x,y,grid,word)
    matches = 0
    neighbours(x,y,grid[0].length,grid.length).each do |nx,ny|
        if grid[y][x] == word[0]
            matches += search_direction(nx,ny,nx-x,ny-y,grid,word[1..-1]) 
        end
    end
    return matches
end

count = 0
(0..input.length-1).each do |y|
    (0..input[0].length-1).each do |x|
        count += start_search(x,y,input,$search_string) 
    end
end

puts count