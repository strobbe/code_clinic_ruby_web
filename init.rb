#! /usr/bin/env ruby

require 'pathname'
require_relative('lib/curriculum.rb')

BASE_DIR = Pathname.new(__dir__)
SITE_DIR = BASE_DIR + 'site'
DATA_DIR = SITE_DIR + '_assets'
HTML_DIR = SITE_DIR + 'programs'

# puts
# puts "Base: #{BASE_DIR}"
# puts "Site: #{SITE_DIR}"
# puts "Data: #{DATA_DIR}"
# puts "HTML: #{HTML_DIR}"
# puts

def get_curriculums
    array = []
    data_files = Dir.glob("#{DATA_DIR}/*_semester.csv")
    data_files.each do |data_file|
        array << Curriculum.new(data_file, true)
    end
    array.sort_by! { |curriculum| curriculum.semester_number }
    return array
end

def print_courses(array)
    array.each do |curriculum|
        puts "#{curriculum.semester_string} Semester"
        puts curriculum.course_list
        puts
    end
end

curriculums = get_curriculums
print_courses(curriculums)