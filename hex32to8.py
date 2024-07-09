# hex32to8.py
import sys

def convert_32bit_to_8bit(input_file, output_file, count_file):
    line_count = 0
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            hex_word = line.strip()
            if len(hex_word) != 8:
                print(f"Skipping invalid line: {line}")
                continue
            line_count += 1
            for i in range(0, 8, 2):
                hex_byte = hex_word[i:i+2]
                outfile.write(hex_byte + '\n')
    
    with open(count_file, 'w') as countfile:
        countfile.write(f"{line_count}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python hex32to8.py <input_file> <output_file> <count_file>")
    else:
        convert_32bit_to_8bit(sys.argv[1], sys.argv[2], sys.argv[3])