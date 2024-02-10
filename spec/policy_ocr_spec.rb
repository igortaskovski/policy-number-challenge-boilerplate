require_relative '../lib/policy_ocr'

describe PolicyOcr::PolicyNumberParser do
  let(:file_path) { File.expand_path("../fixtures/sample.txt", __FILE__) }
  let(:parser) { described_class.new(file_path) }

  context "file loading" do
    it "loads" do
      expect(PolicyOcr).to be_a Module
    end

    it 'loads the sample.txt' do
      expect(fixture('sample').lines.count).to eq(44)
    end
  end

  context "parsing the policy numbers" do
    it "parses the numbers correctly" do
      expect(parser.parse_policy_numbers).to eq(["000000000", "111111111", "222222222", "333333333", "444444444", "555555555", "666666666", "777777777", "888888888", "999999999", "123456789"])
    end

    it "parses each number individually" do
      parsed_numbers = parser.parse_policy_numbers
      expect(parsed_numbers).to include("123456789")
    end
  end

  context "checksum calculations work correctly" do
    it 'returns the correct checksum for a valid policy number' do
      policy_number = "345882865"
      expect(parser.send(:calculate_checksum, policy_number)).to eq(0)
    end

    it 'returns the correct checksum for another valid policy number' do
      policy_number = "123456789"
      expect(parser.send(:calculate_checksum, policy_number)).to eq(0)
    end

    it 'returns the correct checksum for a policy number with leading zeros' do
      policy_number = "000987654"
      expect(parser.send(:calculate_checksum, policy_number)).to eq(0)
    end

    it 'returns the correct checksum for a policy number with trailing zeros' do
      policy_number = "987654000"
      expect(parser.send(:calculate_checksum, policy_number)).to eq(7)
    end

    it 'returns the correct checksum for a policy number with all zeros' do
      policy_number = "111111111"
      expect(parser.send(:calculate_checksum, policy_number)).to eq(1)
    end
  end
end
