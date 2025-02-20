require 'csv'
require_relative 'union_find'
require_relative 'data_normalization'

# CSV processing pipeline for entity grouping
def process_csv(input_file, matching_type)
  rows = []
  headers = nil

  puts "[INFO] Loading input file: #{input_file}"

  # Stream CSV to handle large files efficiently
  CSV.foreach(input_file, headers: true) do |row|
    headers ||= row.headers  # Capture header row
    rows << row.to_h
  end

  row_count = rows.size
  puts "[STAT] Processed #{row_count} rows"

  # Dynamic column detection for flexible input formats
  email_columns = headers.select { |h| h.downcase.include?('email') }
  phone_columns = headers.select { |h| h.downcase.include?('phone') }

  # Initialize data structures for grouping
  uf = UnionFind.new(row_count)
  email_map = {}
  phone_map = {}

  puts "[INFO] Applying matching strategy: #{matching_type}"
  
  rows.each_with_index do |row, idx|
    # Verbose logging for large file processing
    puts "[PROG] Processing row #{idx + 1}/#{row_count}" if idx % 1000 == 0

    # Process email matches
    if %w[same_email same_email_or_phone].include?(matching_type)
      email_columns.each do |col|
        val = normalize_email(row[col])
        next unless val

        # Merge with existing matches or track new value
        email_map.key?(val) ? uf.union(idx, email_map[val]) : email_map[val] = idx
      end
    end

    # Process phone matches
    if %w[same_phone same_email_or_phone].include?(matching_type)
      phone_columns.each do |col|
        val = normalize_phone(row[col])
        next unless val

        # Merge with existing matches or track new value
        phone_map.key?(val) ? uf.union(idx, phone_map[val]) : phone_map[val] = idx
      end
    end
  end

  puts "[INFO] Generating group identifiers"
  person_ids = uf.assign_group_ids

  output_dir = "output"
  Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

  output_file = File.join(output_dir, "grouped_#{File.basename(input_file)}")
  puts "[INFO] Writing output to #{output_file}"

  # Generate output CSV with group IDs
  CSV.open(output_file, 'w') do |csv|
    csv << ['GroupID'] + headers
    rows.each_with_index do |row, idx|
      csv << [person_ids[idx]] + headers.map { |col| row[col] }
    end
  end

  puts "[SUCCESS] Processing completed successfully"
  output_file
end
