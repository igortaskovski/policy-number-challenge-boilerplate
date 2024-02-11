module ChecksumHelper
  # Calculate the checksum for a policy number
  def self.calculate_checksum(policy_number)
    sum = 0
    policy_number.chars.reverse_each.with_index(1) do |digit, index|
      sum += digit.to_i * index
    end
    sum % 11
  end
end
