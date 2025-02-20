require 'benchmark'
require_relative 'lib/csv_processor' 

# Command-line interface for CSV grouping processor
if __FILE__ == $0
  # Validate command-line arguments
  if ARGV.size != 2
    puts "Usage: ruby #{File.basename(__FILE__)} INPUT.csv MATCHING_TYPE"
    puts 'Available matching types: same_email, same_phone, same_email_or_phone'
    exit 1
  end

  input_file = ARGV[0]
  matching_type = ARGV[1].downcase

  # Validate input file existence
  unless File.exist?(input_file)
    puts "[ERROR] Input file not found: #{input_file}"
    exit 1
  end

  # Validate matching type
  unless %w[same_email same_phone same_email_or_phone].include?(matching_type)
    puts "[ERROR] Invalid matching type: #{matching_type}"
    exit 1
  end

  # Execute with performance monitoring
  Benchmark.bm do |bm|
    bm.report("CSV Processing") do
      output_file = process_csv(input_file, matching_type)
      puts "\n[OUTPUT] Result file: #{output_file}\n"
    end
  end
end
