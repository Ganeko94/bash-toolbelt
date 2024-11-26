#!/usr/bin/env python3
import argparse
import pyperclip

def search_lines_with_text(file_path, search_text):
    found_lines = []
    
    try:
        # Open the file in read mode
        with open(file_path, 'r', encoding='utf-8') as file:
            # Iterate through the file lines
            for line_number, line in enumerate(file, 1):
                if search_text in line:
                    found_lines.append(f"Line {line_number}: {line.strip()}")
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
    
    return found_lines

if __name__ == "__main__":
    # Argument parsing
    parser = argparse.ArgumentParser(description="Search for lines containing text in a file.")
    parser.add_argument('file', help="The path to the file")
    parser.add_argument('text', help="The text to search for")
    
    args = parser.parse_args()

    # Call the function with the provided arguments
    lines = search_lines_with_text(args.file, args.text)

    # Check if lines were found
    if lines:
        # Join the lines into a single string for easier copying
        result_text = "\n".join(lines)
        print(result_text)

        # Copy the result to clipboard
        pyperclip.copy(result_text)
        print("\nThe result has been copied to the clipboard.")
    else:
        print(f"No matches found for '{args.text}' in the file.")

