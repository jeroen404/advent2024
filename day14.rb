#!/usr/bin/ruby -w

$part1 = false

class Position < Struct.new(:x,:y)
end

class Velocity < Struct.new(:vx,:vy)
end

class Robot < Struct.new(:position,:velocity)
    def self.parse(line)
        x,y,vx,vy = line.scan(/-?\d+/).map(&:to_i)
        return Robot.new(Position.new(x,y),Velocity.new(vx,vy))
    end

    def move
        position.x = (position.x + velocity.vx) % $max_x
        position.y = (position.y + velocity.vy) % $max_y
    end
end

class Area < Struct.new(:min_x,:max_x,:min_y,:max_y)
    
    def initialize(min_x,max_x,min_y,max_y)
        @middle_x = (min_x+max_x)/2
        @middle_y = (min_y+max_y)/2
        @quadrants = nil
        @rules = []
        super
    end

    def inside?(x,y)
        return min_x <= x && x <= max_x && min_y <= y && y <= max_y
    end
    def get_quadrants
        return @quadrants if @quadrants
        @quadrants = []
        @quadrants << Area.new(min_x,@middle_x-1,min_y,@middle_y-1)
        @quadrants << Area.new(@middle_x+1,max_x,min_y,@middle_y-1)
        @quadrants << Area.new(min_x,@middle_x-1,@middle_y+1,max_y)
        @quadrants << Area.new(@middle_x+1,max_x,@middle_y+1,max_y)
        return @quadrants
    end

    def quadrant_index(robot)
        return nil if ! inside?(robot.position.x,robot.position.y)
        return 0 if robot.position.x < @middle_x && robot.position.y < @middle_y
        return 1 if robot.position.x > @middle_x && robot.position.y < @middle_y
        return 2 if robot.position.x < @middle_x && robot.position.y > @middle_y
        return 3 if robot.position.x > @middle_x && robot.position.y > @middle_y
    end

    def quadrant_scores(robots)
        scores = [0,0,0,0]
        robots.each do |r|
            index = quadrant_index(r)
            scores[index] += 1 if index 
        end
        return scores
    end

    def add_rule(rule)
        @rules << rule
    end

    def all_rules_followed?(robots)
        scores = quadrant_scores(robots)
        return @rules.all? { |r| r.rule_followed?(scores) }
    end

    def display(robots)
        puts 
        (min_y..max_y).each do |y|
            (min_x..max_x).each do |x|
                print robots.find { |r| r.position.x == x && r.position.y == y } ? "#" : "."
            end
            puts
        end
        puts
    end
end

class ScoreRule < Struct.new(:compare)
    def rule_followed?(quadrant_scores)
        return compare.call(quadrant_scores)
    end
end

$max_x = ARGV[0].to_i # 101
$max_y = ARGV[1].to_i # 103

$robots = []
while line_in = $stdin.gets
    $robots << Robot.parse(line_in)
end

world = Area.new(0,$max_x-1,0,$max_y-1)

if $part1
    100.times { $robots.each(&:move) }
    puts world.quadrant_scores($robots).inject(1,:*)
else
    rules = {}
    rules["rule_top_left_smaller_then_bottom_left"] = ScoreRule.new(lambda { |q| q[0] < q[2] })
    rules["rule_top_right_smaller_then_bottom_right"] = ScoreRule.new(lambda { |q| q[1] < q[3] })
    rules["bottom_right_biggest"] = ScoreRule.new(lambda { |q| q[3] > q[0] && q[3] > q[1] && q[3] > q[2] })
    rules["bottom_left_biggest"] = ScoreRule.new(lambda { |q| q[2] > q[0] && q[2] > q[1] && q[2] > q[3] })
    rules["top_right_biggest"] = ScoreRule.new(lambda { |q| q[1] > q[0] && q[1] > q[2] && q[1] > q[3] })
    rules["top_left_biggest"] = ScoreRule.new(lambda { |q| q[0] > q[1] && q[0] > q[2] && q[0] > q[3] })
    
    world.add_rule(rules["rule_top_left_smaller_then_bottom_left"])
    world.add_rule(rules["rule_top_right_smaller_then_bottom_right"])
    world_quadrants = world.get_quadrants
    world_quadrants[0].add_rule(rules["bottom_right_biggest"])
    world_quadrants[1].add_rule(rules["bottom_left_biggest"])
    world_quadrants[2].add_rule(rules["top_right_biggest"])
    world_quadrants[3].add_rule(rules["top_left_biggest"])
    top_left_quadrants = world_quadrants[0].get_quadrants
    top_left_bottom_right = top_left_quadrants[3]
    top_left_bottom_right.add_rule(rules["bottom_right_biggest"])
    bottom_left_quadrants = world_quadrants[2].get_quadrants
    bottom_left_top_right = bottom_left_quadrants[1]
    bottom_left_top_right.add_rule(rules["top_right_biggest"])
    bottom_right_quadrants = world_quadrants[3].get_quadrants
    bottom_right_top_left = bottom_right_quadrants[0]
    bottom_right_top_left.add_rule(rules["top_left_biggest"])
    iterations = 0
    loop do
        $robots.each(&:move)
        iterations += 1
        if world.all_rules_followed?($robots) && world_quadrants.all? { |q| q.all_rules_followed?($robots) }
            if top_left_bottom_right.all_rules_followed?($robots) && \
               bottom_left_top_right.all_rules_followed?($robots) && \
               bottom_right_top_left.all_rules_followed?($robots)
                break
            end
        end        
    end
    puts iterations
end

#world.display($robots)

