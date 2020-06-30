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
Okay, I believe my HTML (now HTML.ERB) is sufficiently hacked up. It had four tables for the four semesters. I took it down to one table, wrapped it in code to loop through the curriculums, and replaced the series of rows with code to write a row for each course within a curriculum. I'm not sure yet how to get the curriculums variable into the file. I'll start building the init.rb that will throw everything together, and that's probably where I'd create the ERB instances and pass them as variables.

## 2020-06-29 19:01:18
In between numerous interruptions, I've completed a basic program that:

1. Reads any available CSV files in the `_assets` directory (need a way to reject any that aren't the right format)
2. Creates `Curriculum` objects from those files
3. Puts those objects in an array (sorted by semester number)
4. Prints a list of courses in each `Curriculum`

In the `init.rb`, steps 1-3 are in a function, step 4 is another. The second is mostly for demonstration, as it does basically the same thing as the loop in the ERB template.

Now to figure out how to get the curriculums array into there.

## 2020-06-29 20:18:44
And I'm done. init.rb is complete and successfully "injects" the array of Curriculum objects into the ERB template file and writes the result to an appropriately named HTML file. The ERB constructor has an option called eoutvar that can be used to send a variable. I used that to include the array of Curriculum objects, but I'm not clear yet how to send multiple variables. A hash, maybe? Or perhaps it has something to do with "bindings." After I watch the solution videos for the Code Clinic, I'll look more into templating and see how it's supposed to be done.

## 2020-06-29 22:34:03
Now to see how my solution differs from the official one. 


### Overview

As far as organization, he put his ERB file under `_assets` instead of under programs where I had it. That makes sense -- put all the pre-compiled files one place and the compiled ones another. On a real website, programs is probably where all the degree program pages would be. He also gave his main program file a more meaningful name (`merge_template.rb`). I was just used to all the programs in the rest of the series being started with init.rb.

### Parsing CSV Files

He's going with CVS.read to get the contents of the CSV files whereas I went with CVS.foreach to loop through the rows right away. I'm not sure yet what are the advantages of either.

Sidenote: I'm peaking at the Ruby file for the CVS class. I should look through it and see how it does what it does.

### ERB Templating

I know a fair amount about writing ERB templates from using Rails, but this video should give me a better understanding of how the rendering works. Speaking of which, he calls an ERB instance a "renderer." Makes sense.

Oh, good, he's talking about using instance variables in templates now. Maybe he'll explain how to pass multiple variables. "So the output uses values of variables as they are at the time that result is called, not back when the ERB instance was originally defined." Oh, I get it. You don't need to pass the variable to the ERB instance. It uses whatever (instance, I assume) variables it has access to when its #result is called. Huh. So what's eoutvar for?

But he's not covering eoutvar. He's talking about...bindings. It's taking me a bit to wrap my head around them at how they fit in with ERB templating. The steps he takes in giving a basic example (in which the template is just a string using a variable) are:

1. Inside the class, have accessors for some variable (for example, `:name`) and a `:template`
2. Define a #render method with the line `ERB.new(@template).result(binding)`
3. Then create an instance of the class, assign a value to the variable (`name`), and assign a template (string or file) to the `template`
4. Call the instance's `#render` method to get the merged result.

Creating the ERB instance inside the class and passing bindings to `#result` gives it the access it needs to that instance's variables. This gives me an idea for another project I've been working on (or was before I started spending so much time on these lessons).

Yeah, I'm guessing he wrote his class and the merge file quite a bit differently from how I did. Hurm. Mine works, but I guess it's not technically correct.

### CurriculumMaker

Well, I already know he has a render or similar method in his class. Seems weird to me to have that in a class. What if you never have to render anything from it? And don't you then have to add the method to any class if you later decide you do need to render it to, say, a web page? It's a simple enough method, I guess, so probably not a big deal.

Now I'm curious enough to write another version using his method. So I will.

### Parsing Course Data

I prefer the way I parseed the data, but I can see why he went the way he did. My class takes the CSV data and creates an array of hashes. Each hash is a course with keys for course :code, :name, and :hours. I use the Curriculum class to identify the courses for a particular semester, whereas he apparently will be creating a single instance of his CurriculumMaker class to hold all semesters. He keeps them separate by having each semester be a hash -- with the header (used in the web page table) as one value, and the array of courses as the other value.

### Creating an ERB Template

I'm guessing the ERB template I created for my solution will be very similar. Or maybe not since we structred our data very differently. Mostly the variables will be different, but the structure of the code should be mostly the same.

I like the way he separates the course code from the course name. I knew there had to be a way to do it in one line, but couldn't figure it out. What I ended up doing -- in my Curriculum class, though, not in the template was to split the whole entry, shift out the code, and then rejoin the rest back into a full string:

```ruby
codename = row[0].split
course[:code] = codename.shift
course[:name] = codename.join(' ').strip
```

I wanted to do it all in one line but couldn't figure out how. What I didn't realize is that you can pass a number to #split to say how many items it should return. But passing it a 2, that keeps the the course name together. And I forgot about assigning an array of items to multiple varibles. Like so (his example but using my variables):

```ruby
course[:code], course[:name] = row[0].split(' ', 2)
```
Sweet.

Final note from the video: Add `include ERB::Util` to the classes that will have content rendered and in the template use `h()` around outputted data to escape it. For security reasons.

### Using the ERB template

One more change to the `Curriculum` class (`CorriculumMaker` in the official solution) is to write an #add_template method that allows a template to be assigned after initialization. Then back to the main program file, add a line to call that method and pass our `.html.erb` file, and have a look at the rendered content. A few typo corrections later and it works! Well, it renders an HTML file to the screen. As HTML. Saving to a file comes next.

### Saving Results to a New File

Couple tips from this video: When using File.open() to write to a file, 1) use a block with File.open() to create a file as this wil close the file automatically when it's done, and 2) inside that block, use the object's write method to write to the file. I was using the append operatore. Which is probably fine, but I suspect this is more standard.

Okay, let's run this and see what typos I made.

Hey, no typos!

He just answered my earlier question: Rails does not store rendered HTML files that it generates. It just sends it to the client browser.