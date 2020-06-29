# What Is This?

This is for part 6 of the Code Clinic: Ruby series on LinkedIn Learning (formerly Lynda.com). For parts 1 through 5, I went right to the instructor's (Kevin Skoglund) videos explaining how he accomplished a particular task, and I wrote his code as he demonstrated it. In part 5, I decided to do as he suggests at the beginning of each part: Try writing your own solution. I'm pretty pleased with what I came up with in part 5, so I'm doing it again for part 6.

# What's Part 6?

Part 6 of the Code Clinic is "Building the Web." From the looks of the video titles, it involves basing the content of a website on CSV files. Sort of a low-cost, no frills database based site. It also seems to use ERB templates, very similarly (if not almost exactly) like Rails. Let's watch his intro and "Hints, Tips, and tricks" video to see the expecations. I probably will wait on viewing his solution overview video.

# The Task, Hints, Tips, and Tricks
The task is to combine template files and CSV files to generate web pages. The CSV files contain course data for a school. Good thing I'm watching the Hints, etc video because the first thing he mentions is that we'll want to use two Ruby libraries: CSV and ERB. I'd planned on the first one but didn't realize there was an ERB library. I figured I had to come up with my own templating system. I had no idea how I was going to make my program interpret `<% %>` tags.) I guess that's how, with the ERB library.

He's recommending as a starting point the CSV files and final HTML from James Williamson's Dreamweaver CC Essential Training course. I thought about just using the CSV and writing my own HTML, but skip it. This is a Ruby Code Clinic. Skoglund provided them in his exercise files, too.

Okay, so the project just involves having a program that takes the template files (presumeably .html.erb like Rails uses) and combining them with the CSV data and saving it all to HTML file(s). (So, do systems like Rails actually save the combined files to disk and then...delete them? Or just build them in memory and return them over the net? Probably the latter.)

Okay, here we go.

## 2020-06-29 11:35:11
Started by copying the static files from the Code Clinic exercise files. I could not find a Dreamweaver CC Essential Training course by Jason Williamson, so it's a good thing Skoglund provided them. The project has a bunch of images that aren't used on the single HTML page we'll be using, so I opened that page to see what images it actually uses and deleted the rest. I also deleted several fonts and a couple javascript files that aren't not used. I'm live-serving the page now and (other than the internal links not working because it's the only page I have), it looks fine.

Now to figure out how to use ERB.

## 2020-06-29 11:58:40

```console
strobbe@Crow:~/rubyexp/lil_ruby_clinic/part6_web_rs$ ri erb`
Nothing known about .erb`
```

Heh. So, `ri` (which I've never used before, but I saw it mentioned recently) knows that .erb is a file extension, but it has "nothing known" about it. I was hoping to just get a basic idea of how to use it without stumble across any spoon-feeding. Oh well, to the internet!

So the first example from [https://ruby-doc.org/stdlib-2.7.1/libdoc/erb/rdoc/ERB.html] creates a class that has data in a hash and a build method. The build method creates a new instance of an ERB object, passing a string that includes `<% %>` tags to output the hash to a formatted string. The example doesn't have any HTML, but I assume it could. I also assume that an ERB object could be passed an `.erb` file. Yes? Maybe?

Ah, yes, next example (though it's not specifically about creating ERB instances) calls File.read() on a file, and the whole thing is passed to a new ERB instance. And then the filename is also assigned to the instance's `filename` variable. I think I need to go into IRB (not to be confused with ERB) for a bit and play with this.

```ruby
# testing.html.erb
<% @justvar = "I'm just a value." %>

<h1><%= "He says '#{@justvar}'" %></h1>
```

```ruby
# irb activity
2.7.0 :001 > require 'erb'
=> true 
2.7.0 :002 > fn = "testing.html.erb"
2.7.0 :003 > erb = ERB.new(File.read(fn))
2.7.0 :004 > erb.filename = fn
2.7.0 :005 > pp erb
#<ERB:0x000055efc488ce58
 @_init=#<Class:ERB>,
 @encoding=#<Encoding:UTF-8>,
 @filename="testing.html.erb",
 @frozen_string=nil,
 @lineno=0,
 @src=
  "#coding:UTF-8\n" +
  "_erbout = +'';  @justvar = \"I'm just a value.\" ; _erbout.<< \"\\n\\n<h1>\".freeze\n" +
  "\n" +
  "; _erbout.<<(( \"He says '\#{@justvar}' ).to_s); _erbout.<< \"</h1>\".freeze; _erbout">
 => #<ERB:0x000055efc488ce58 @src="#coding:UTF-8\n_erbout = +'';  @justvar = \"I'm just a value.\" ; _erbout.<< \"\\n\\n<h1>\".freeze\n\n; _erbout.<<(( \"He says '\#{@justvar}' ).to_s); _erbout.<< \"</h1>\".freeze; _erbout", @encoding=#<Encoding:UTF-8>, @frozen_string=nil, @filename=nil, @lineno=0, @_init=#<Class:ERB>>
```
Interesting... But what do I do with it? Okay, I see an example that uses a #result method to output the result of the Ruby code. But it also does something with binding. I don't know if I'll need that. I think I better try an example using a class, and this all may make more sense then.

## 2020-06-29 13:41:29

After testing, I've determiend the steps:

1. Write the `.html.erb` template file with Ruby code
2. Create an instance of `ERB`, passing that template file inside `File#read`
3. Create a new file using `File#new` -- For simplicity, set this to a variable
4. Send the #result of the `ERB` instance to the new file
5. Close the new file

I'm still playing with the `ERB` to get the hang of it. I found the `trim_mode` option, but am still getting more blank lines that I'd like.

## 2020-06-29 14:01:45
Okay, got the blank lines settled by changing the trim_mode (using ">" instead of "<>"). I was still getting some extra spaces (my testing involved outputing a list from an array), and I got through that by not indending my Ruby lines in the template file. I shouldn't think those would have an impact on the non-Ruby lines, but they did. I didn't have that issue with Rails (or maybe I wasn't paying much attention to the spacing of the rendered HTML).

So, do I toy around with the CSV files now or start hacking up the project's HTML file to make a template? According to the video titles, Skoglund addressed the CSV files next. Guess I'll take a look at those.

FYI:

```ruby
# drinks.html.erb
<% drinks = ["Dr. Pepper", "Diet Coke", "Root Beer", "Gatorade", "Pepsi??", "water"] %>
<% if drinks %>
<ul>
<% drinks.each do |d| %>
    <li><%= d %></li>
<% end %>
</ul>
<% end %>

```
```ruby
# irb activity
2.7.0 :023 > erb = ERB.new(File.read("drinks.html.erb"), trim_mode: ">")
2.7.0 :024 > outfile = File.new("drinks.html", "w")
2.7.0 :025 > outfile << erb.result
 => #<File:drinks.html> 
2.7.0 :026 > outfile.close
```

```html
<!-- drinks.html -->
<ul>
    <li>Dr. Pepper</li>
    <li>Diet Coke</li>
    <li>Root Beer</li>
    <li>Gatorade</li>
    <li>Pepsi??</li>
    <li>water</li>
</ul>
```

## 2020-06-29 14:26:39
So, I'm looking a the CSV files and the HTML file. The project is a school's page for a Graphics Design degree. The dynamic part is the curriculum list, which is stored in the CSV files: first_semester.csv and second_semester.csv. (The HTML file has listings for four semesters. What's up with that?)

Each CSV file is two "columns." The first, with a heading designating the semester, is the course number and name. Second column, with the heading "credit hours," is just that. I noticed that the HTML file has the course number in bold, so that'll need to be isolated. No problem. Split the "semester" column by spaces, take the first item for course number, and rejoin the rest.

## 2020-06-29 16:04:03
I have a basic `Curriculum` class that can be passed a CSV file. It has a more user-friendly #title based on the filename (I should have a setter in case the filename is particuarly ugly), and `#get_data` to actually retrieve the contents of the file. As I started writing code to work with the data, I decided to get to know the CSV class a little better, so I'm reading its docs.

## 2020-06-29 16:54:27
My `Curriculum` class now retrieves data from the CSV file and parses it into an array of hashes with `:code`, `:name`, and `:hours`. Time to hack up some HTML. (There's not really much to do. The only dynamic part right now would be a couple tables to display the curriculum data. Maybe I'll add some other dynamic elements to make things interesting.)

## 2020-06-29 17:35:00
Okay, I believe my HTML (now HTML.ERB) is sufficiently hacked up. It had four tables for the four semesters. I took it down to one table, wrapped it in code to loop through the curriculums, and replaced the series of rows with code to write a row for each course within a curriculum. I'm not sure yet how to get the curriculums variable into. I'll start building the init.rb that will throw everything together, and that's probably where I'd create the ERB instances and pass them as variables.