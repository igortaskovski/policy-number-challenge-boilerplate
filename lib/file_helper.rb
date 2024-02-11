module FileHelper
  def self.write_to_file(output_path, data)
    begin
      File.open(output_path, "w") do |f|
        data.each do |line|
          f.puts line
        end
      end
    rescue StandardError => e
      puts "Error writing to file: #{e.message}"
    end
  end
end
