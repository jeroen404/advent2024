#!/usr/bin/ruby -w

class OrderRule < Struct.new(:before,:after)
    def self.parse(line)
        before, after = line.split("|").map(&:to_i)
        return OrderRule.new(before, after)
    end

    def rule_followed?(update)
        before_i = update.index(self.before)
        after_i = update.index(self.after)
        return before_i.nil? || after_i.nil? || before_i < after_i
    end
end

class Update < Array
    def self.parse(line)
        return Update.new(line.split(',').map(&:to_i))
    end

    def middle_page
        middle = (self.length / 2).ceil
        return self[middle]
    end
end

orderrules = []
updates = []

# read from stdin
while line = gets
    if line == "\n"
        break
    end
    orderrules << OrderRule.parse(line.chomp)
end
while line = gets
    updates << Update.parse(line.chomp)
end

puts updates.filter { |update| orderrules.all? { |rule| rule.rule_followed?(update) } }.map(&:middle_page).inject(0, :+)




