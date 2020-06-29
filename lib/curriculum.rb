require 'csv'

class Curriculum
    def initialize(filename, populate=false)
        @file_base = filename
        @courses = populate ? get_data! : []
    end

    def semester_string
        temp = File.basename(@file_base, ".csv")
        temp.split("_").first.capitalize
    end

    def semester_number
        ["first", "second", "third", "fourth"].find_index(self.semester_string.downcase) + 1
    end

    def get_data
        data = []
        CSV.foreach(@file_base, headers: true) do |row|
            course = {}
            codename = row[0].split
            course[:code] = codename.shift
            course[:name] = codename.join(' ')
            course[:hours] = row[1].to_i
            data << course
        end
        return data
    end

    def get_data!
        @courses = get_data
    end

    def courses
        @courses
    end

    def course_list
        list = ""
        @courses.each do |course|
            list << "#{course[:code]}\t#{course[:name]} (#{course[:hours].to_s} cr hrs)\n"
        end
        list
    end
end