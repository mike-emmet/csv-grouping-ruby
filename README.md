# Ruby Grouping Assessment Solution

## Overview
This script processes CSV files to group rows representing the same person based on matching criteria:
- **same_email**: Groups rows with identical email addresses.
- **same_phone**: Groups rows with identical phone numbers.
- **same_email_or_phone**: Groups rows sharing either email or phone.

Utilizes **Union-Find (Disjoint-Set)** for efficiency.

## Features
- **Efficient CSV Processing**: Handles large files without loading everything into memory.
- **Dynamic Column Detection**: Automatically detects relevant columns.
- **Data Normalization**: Standardizes email and phone formats.
- **Optimized Grouping**: Uses path compression and union-by-rank.
- **Clear Logging**: Provides progress updates and error handling.

## File Structure
```
ruby-grouping/
├── input/                        # Stores input CSV files
├── lib/                          # Contains core logic files
│   ├── csv_processor.rb          # CSV handling logic
│   ├── data_normalization.rb     # Email & phone normalization
│   ├── union_find.rb             # Union-Find implementation
├── output/                       # Stores generated output files (gitignored)
├── main.rb                       # Entry point
├── README.md                     # Documentation
```

## Installation
1. Install Ruby (2.7+)
2. Clone the repository.
3. Run the script:
   ```bash
   ruby main.rb input/input1.csv same_email_or_phone
   ```

## Output
Creates a `output/grouped_<input_file>.csv` with an added `GroupID` column.

## Performance
- **Time Complexity**: ~O(n α(n)) (near constant time per operation)
- **Space Complexity**: O(n)
- **Benchmarking**: Measures execution time for performance analysis.

## Example
### Input (`input/input1.csv`)
```csv
FirstName,LastName,Phone,Email
John,Smith,5551234567,john@example.com
Jane,Doe,5551234567,jane@example.com
```
### Command
```bash
ruby main.rb input/input1.csv same_email_or_phone
```
### Output (`output/grouped_input1.csv`)
```csv
GroupID,FirstName,LastName,Phone,Email
1,John,Smith,5551234567,john@example.com
1,Jane,Doe,5551234567,jane@example.com
```
