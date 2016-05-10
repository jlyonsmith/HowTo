# Ruby

A cheat sheet for [Ruby 2.0](http://rubylang.org).
## Comments
```ruby
# Anything after a hash symbol is a comment
```
## If/Then/Else
```ruby
if value
	# Something
elsif other_thing
	# Something else
else
	# Or do this
end
```
## Unless/Else
```ruby
unless value
	# Something
else
	# Something else
end
```
## Define a Class with Constructor
```ruby
class MyClass
	def initialize(x,y,z)
		...
	end
end
```
## Create Instance of Class
```ruby
x = MyClass.new(1,2,3)
x = MyClass.new
```
## Define Instance Method
```ruby
class MyClass
	def my_func
		...
	end
end
```
## Define Class Method
```ruby
class MyClass
	def self.my_other_func
		…
	end
end
```
## Define Instance Variable
```ruby
class MyClass
	def initialize
		@i_am_instance = 'thing'
	end
end
```
## Multi-line String
```ruby
x = <<FOO
string
contents
    with spacing and line
breaks
FOO

y = %q(
string with #{x}
not interpolated
)
	
y = %Q(
string with #{x}
interpolated
)
```
## Case Statement (Switch)
```ruby
case x
when 'A'
	...
when 'B','C'
	...
else
	...
end

x = 'abc'
case
when x.match(/ab/)
	...
else x == '123'
	...
end
```
## Attributes (Properties)
```ruby
class MyClass
	attr_reader :var1  # def var1; @var1; end
	attr_writer :var2  # def var2(value); @var2 = value; end
	attr_accessor :var3, :var4 # var3 & var4 have both methods
end
```
## Require, Load, Include, Extend
```ruby
include 'somefile.rb' # Mixes in the source code, as instance methods in a class
extend 'somefile.rb' # Mixes in the source code, as class methods
load 'otherfile.rb' # Loads the file
require 'somelib' # Loads the library only once
require_relative 'localfile.rb' # Loads relative file only once
```
## Show Variable Class
```ruby
my_var.class
```
## Conversion Idiom
```ruby
class MyClass
	...
end

def MyClass(obj)
	# Convert obj to MyClass
end

MyClass(10) # Converts Fixnum to new MyClass instance if possible
```
## Compare Item Class
```ruby
case my_var
	when Fixnum
		# Something
	when String
		# Something
	else
		# Catch all
end
```
