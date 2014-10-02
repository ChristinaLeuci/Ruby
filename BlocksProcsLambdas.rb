# Block Examples

[1,2,3].each { |x| puts x*2 }   # block is in between the curly braces

[1,2,3].each do |x|
  puts x*2                    # block is everything between the do and end
end

{ puts "Hello World"}       # syntax error  
a = { puts "Hello World"}   # syntax error
[1,2,3].each {|x| puts x*2} # only works as part of the syntax of a method call
*-------------------------------------------------------------------------*

# Proc Examples             
p = Proc.new { |x| puts x*2 }
[1,2,3].each(&p)              # The '&' tells ruby to turn the proc into a block 

proc = Proc.new { puts "Hello World" }
proc.call                     # The body of the Proc object gets executed when called
proc.class                    # returns 'Proc'
a = p                         # a now equals p, a Proc instance
p                             # returns a proc object '#<Proc:0x007f96b1a60eb0@(irb):46>'

def multiple_procs(proc1, proc2)
  proc1.call
  proc2.call
end

a = Proc.new { puts "First proc" }
b = Proc.new { puts "Second proc" }

multiple_procs(a,b)
*----------------------------------------------------------------------------*

# Lambda Examples            
lam = lambda { |x| puts x*2 }
[1,2,3].each(&lam)

lam = lambda { puts "Hello World" }
lam.call
*-----------------------------------------------------------------------------*

proc   # returns '#<Proc:0x007f96b1032d30@(irb):75>'
lam    # returns '<Proc:0x007f96b1b41938@(irb):76 (lambda)>'

lam = lambda { |x| puts x }    # creates a lambda that takes 1 argument
lam.call(2)                    # prints out 2
lam.call                       # ArgumentError: wrong number of arguments (0 for 1)
lam.call(1,2,3)                # ArgumentError: wrong number of arguments (3 for 1)

proc = Proc.new { |x| puts x } # creates a proc that takes 1 argument
proc.call(2)                   # prints out 2
proc.call                      # returns nil
proc.call(1,2,3)               # prints out 1 and forgets about the extra arguments

*------------------------------------------------------------------------------*
# Example of Proc objects preserving local context

def counter
  n = 0
  return Proc.new { n+= 1 }
end

a = counter
a.call            # returns 1
a.call            # returns 2

b = counter
b.call            # returns 1

a.call            # returns 3