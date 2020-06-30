#! /usr/bin/env ruby

require 'pathname'
require 'erb'
require_relative('lib/curriculum.rb')

BASE_DIR = Pathname.new(__dir__)
SITE_DIR = BASE_DIR + 'site'
DATA_DIR = SITE_DIR + '_assets'
HTML_DIR = SITE_DIR + 'programs'
TEMPLATE_FILE = 'graphic-design.html.erb'

def get_curriculums
    array = []
    data_files = Dir.glob("#{DATA_DIR}/*_semester.csv")
    data_files.each do |data_file|
        array << Curriculum.new(data_file, true)
    end
    array.sort_by! { |curriculum| curriculum.semester_number }
    return array
end

def inject_courses(array, template)
    source_path = HTML_DIR + template
    erb = ERB.new(File.read(source_path), eoutvar: "array")
    return erb    
end

def print_courses(array)
    array.each do |curriculum|
        puts "#{curriculum.semester_string} Semester"
        puts curriculum.course_list
        puts
    end
end

def write_html(erb)
    outpath = (HTML_DIR + TEMPLATE_FILE).sub_ext('')
    outfile = File.new(outpath, "w")
    outfile << erb.result
    outfile.close
end

@curriculums = get_curriculums
# print_courses(curriculums)
erb = inject_courses(@curriculums, TEMPLATE_FILE)
write_html(erb)