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

    # Check if a policy number is valid
    def valid_policy_number?(policy_number)
      checksum = calculate_checksum(policy_number)
      checksum == 0
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

    # Calculate the checksum for a policy number
    def calculate_checksum(policy_number)
      sum = 0
      policy_number.chars.reverse_each.with_index(1) do |digit, index|
        sum += digit.to_i * index
      end
      sum % 11
    end
  end
end
