# Kin Coding Challenge

  This was a very interesting project which involved reading a scanned file and parsing the insurance policy numbers into actual numbers and then writing them to another file.

  I have decided to keep most the logic contained in the `PolicyOcr` module because it is related to the functionality, but moved the checksum calculation and the logic for writing to a file to their own modules, `ChecksumHelper` and `FileHelper` respectively.

## User Story 1
  The first task in the coding challenge is to write a program that can read a file with scanned policy numbers and parse it into actual numbers.
  The code is contained within the `PolicyNumberParser` class which initially only took one argument (`file_path`) to fulfil User Story 1, but later I updated the initializer to take two arguments, `input_file_path` and `output_file_path`.
  I created a map of each digit, represented in the code as `DIGIT_MAP`. 
#### parse_policy_numbers
  I wrote a method called `parse_policy_numbers` which opens the file from the `input_file_path`, reads line by line and parses each line as a policy number. The interesting part here is the `.each_slice(4)` method which divides the lines read from the file into slices of four consecutive lines. This assumes that each policy number is represented by four lines in the file. Then I call the `parse_single_number(policy_number)` and pass the `policy_number` slice to it for parsing. The parsed result is then appended to the `policy_numbers` array.
#### parse_single_number
  The `parse_single_number(policy_number)` takes a single argument `policy_number`, representing a slice of four lines from a file, each line potentially containing digits and returns the parsed number as a result.
  If the input is not an array with four elements, I raise an error. I discard the last element of the array as that is not part of the digits representation. Each number consists of 9 digits, so I initialize an empty array with 9 elements for easy manipulation later on to store each digit. I loop through each element in the input array and using `line.scan(/.{3}/).each_with_index` I scan each line in the policy_number slice, dividing it into groups of three characters (presumably digits). Then I iterate over each group of three characters and their index within the line and append each group to the corresponding index in the placeholder array.
  In the next step, I loop through the `placeholder` array and do `if DIGIT_MAP.key?(p)` which checks if the digit representation exists in `DIGIT_MAP` and if it does, I append the digit to the `digits` string, otherwise I append a `?` which also fulfils part of the requirements for User Story 3.

## User Story 2
#### calculate_checksum
  In this user story, my task was to write some code that calculates the checksum for a given number by using the provided equation, and based on the result it identifies if it is a valid policy number or not.
  I achieved this by writing the `calculate_checksum(policy_number)` function which takes a policy number as an input and returns an integer representing the checksum. If the result is 0, the checksum is valid, otherwise it's invalid. I implemented the math equation by iterating over each character of the policy_number array in reverse order, starting from the last character, getting their index (starting from 1) and then calculating the weighted sum for each digit of the policy number. I convert each digit to an integer, then multiply it by its index and add it to the running sum. At the end, I calculate the remainder of the sum divided by 11 which is the checksum value.

#### valid_policy_number?
  This method just gets the checksum number and checks if it's 0. If it is, it returns true, otherwise returns false.

## User Story 3
  The user story 3 requires processing of the parsed policy numbers to determine if they are valid (checksum is 0) or illegible (some of the digits could not be parsed). As part of this user story, I create a method named `process` which is responsible of getting the parsed policy numbers from `parse_policy_numbers` and does additional processing before writing them to an output file.
  The next step is passing the parsed numbers to `process_policy_numbers` which will process each policy number from the array and append additional information based on certain conditions. It will call `illegible_policy_number?` to check if the number includes a `?` and append " ILL" if it does, and in another case it will call `valid_policy_number?` which checks the checksum and returns true or false and it will append " ERR" if the method returns false. After that processing is complete, I call the `FileHelper.write_to_file` helper method to write the data to an output file (the output path was passed when we initialized the parser).

### Instructions
Project Dependencies:
```
ruby 2.7.8
```
Install Ruby:
```
asdf install # if using asdf

or 

brew install ruby@2.7
```
If you are getting errors about bundler version (since the provided Gemfile.lock) was bundled with 2.0.2, you might have to install that specific version:
```
gem install bundler -v 2.0.2
```
Install dependencies:
```
bundle install
```
Run specs:
```
bundle exec rspec
```

Load the project in IRB or Pry:
```
irb -r ./lib/policy_ocr.rb
```
or 
```
pry -r ./lib/policy_ocr.rb
```
 Call the process method:
```
input_file_path = File.expand_path("../spec/fixtures/sample.txt", __FILE__)
output_file_path = File.expand_path("../output/output.txt", __FILE__)
parser = PolicyOcr::PolicyNumberParser.new(input_file_path, output_file_path)
parser.process
```
The processing will output the result in the console which looks like this:
```
=> ["000000000", "111111111 ERR", "222222222 ERR", "333333333 ERR", "444444444 ERR", "555555555 ERR", "666666666 ERR", "777777777 ERR", "888888888 ERR", "999999999 ERR", "123456789", "5?55555?5 ILL"]
```
and it will write the data into a file named `./output/output.txt`.
