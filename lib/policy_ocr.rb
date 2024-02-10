module PolicyOcr
  class PolicyNumberParser
    require 'pry'

    DIGIT_MAP = {
      " _ | ||_|" => 0,
      "     |  |" => 1,
      " _  _||_ " => 2,
      " _  _| _|" => 3,
      "   |_|  |" => 4,
      " _ |_  _|" => 5,
      " _ |_ |_|" => 6,
      " _   |  |" => 7,
      " _ |_||_|" => 8,
      " _ |_| _|" => 9
    }

    def initialize(file_path)
      @file_path = file_path
    end

    # Parse the policy numbers from the file
    def parse_policy_numbers
      policy_numbers = []

      # Read the file line by line and parse each policy number
      File.foreach(@file_path).each_slice(4) do |policy_number|
        policy_numbers << parse_single_number(policy_number)
      end
      policy_numbers
    end

    private

    # Parse a single policy number
    def parse_single_number(policy_number)
      policy_number.pop
      placeholder = Array.new(9, '')

      policy_number.each do |line|
        line.scan(/.{3}/).each_with_index do |digit, i|
          placeholder[i] += digit
        end
      end

      digits = ""

      placeholder.each do |p|
        if DIGIT_MAP.key?(p)
          digits += DIGIT_MAP[p].to_s
        else
          digits += "?"
        end
      end

      digits
    end
  end
end
