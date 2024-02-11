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

    def initialize(input_file_path, output_file_path)
      @input_file_path = input_file_path
      @output_file_path = output_file_path
    end

    # Process the policy numbers and write the results to a file
    def process
      policy_numbers = parse_policy_numbers
      puts("policy_numbers: #{policy_numbers}")
      processed_numbers = process_policy_numbers(policy_numbers)
      write_to_file(@output_file_path, processed_numbers)
    rescue StandardError => e
      puts "Error processing policy numbers: #{e.message}"
    end

    # Parse the policy numbers from the file
    def parse_policy_numbers
      policy_numbers = []

      begin
        # Read the file line by line and parse each policy number
        File.foreach(@input_file_path).each_slice(4) do |policy_number|
          policy_numbers << parse_single_number(policy_number)
        end
      rescue Errno::ENOENT => e
        raise "Error: File not found - #{@file_path}"
      rescue Errno::EACCES => e
        raise "Error: Permission denied - #{@file_path}"
      rescue StandardError => e
        raise "Error parsing policy numbers: #{e.message}"
      end

      policy_numbers
    end

    # Check if a policy number is valid
    def valid_policy_number?(policy_number)
      checksum = calculate_checksum(policy_number)
      checksum == 0
    end

    # Check if a policy number is illegible
    def illegible_policy_number?(policy_number)
      policy_number.include?("?")
    end

    # Write the policy numbers to a file
    def write_to_file(output_path, policy_numbers)
      begin
        File.open(output_path, "w") do |f|
          policy_numbers.each do |policy_number|
            f.puts policy_number
          end
        end
      rescue StandardError => e
        puts "Error writing to file: #{e.message}"
      end
    end

    private

    # Parse a single policy number
    def parse_single_number(policy_number)
      raise ArgumentError, "Invalid policy number format" unless policy_number.is_a?(Array) && policy_number.size == 4

      begin
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

      rescue StandardError => e
        raise "Error parsing single policy number: #{e.message}"
      end
    end

    # Calculate the checksum for a policy number
    def calculate_checksum(policy_number)
      sum = 0
      policy_number.chars.reverse_each.with_index(1) do |digit, index|
        sum += digit.to_i * index
      end
      sum % 11
    end

    # Process policy numbers to find invalid and illegible numbers
    def process_policy_numbers(policy_numbers)
      processed_policy_numbers = []

      policy_numbers.each do |policy_number|
        case
          # Check for illegible policy numbers and append " ILL"
          when illegible_policy_number?(policy_number)
            processed_policy_numbers << "#{policy_number} ILL"
          # Check for invalid policy numbers and append " ERR"
          when !valid_policy_number?(policy_number)
            processed_policy_numbers << "#{policy_number} ERR"
          else
            # Valid policy numbers
            processed_policy_numbers << policy_number
        end
      end

      processed_policy_numbers
    end
  end
end
