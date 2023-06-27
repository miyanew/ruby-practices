#!/usr/bin/env ruby
# frozen_string_literal: false

# this class is Fizzbuzz
class Fizzbuzz
  index_from = 1
  index_to = 20

  (index_from..index_to).each do |num|
    if num.modulo(3 * 5).zero?
      puts 'FizzBuzz'
      next
    end

    if num.modulo(3).zero?
      puts 'Fizz'
      next
    end

    if num.modulo(5).zero?
      puts 'Buzz'
      next
    end

    puts "#{num}"
  end
end

Fizzbuzz
