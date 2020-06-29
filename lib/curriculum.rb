require 'csv'

class Curriculum
    def initialize(filename, populate=false)
        @file_base = filename
        @courses = populate ? get_data! : []
    end

    def title
        temp = File.basename(@file_base, ".csv")
        temp.split(/ |\_/).map(&:capitalize).join(" ")
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
end