The default templating language is Embedded Ruby(ERB)
In ERB we have three main markup elements:

HTML and text use no markers and appear plainly on the page
<%= and %> wrap Ruby code whose return value will be output in place 
of the marker.
<% and %> wrap Ruby code whose return value will NOT be output.
<%- and %> wrap Ruby code whose return value will NOT be output and 
no blank lines will be generated.

ERB works with any text format, it outputs javascript, html, etc.
ERB doesn’t know anything about the surrounding text. It just injects
 printing or non-printing Ruby fragments into plaintext.

Enter HAML
It encourages stringent formatting of your view templates, lightens
 the content significantly, and draws clear lines between markup and
  code.

a white-space templating engine
In a typical template we’d have plain HTML like this:

<h1>All Articles</h1>
Using whitespace to reflect the nested structure, we could reformat
 it like this:

<h1>
  All Articles
</h1>
And, if we assume that whitespace is significant, the close tag would
 become unnecessary here. The parser could know that the H1 ends when
  there’s an element at the same indentation level as the opening H1 
  tag. Cut the closing tag and we have:

<h1>
  All Articles
The H1 tag itself is heave with both open and close brackets. Leaving
 just <h1 as the HTML marker could have worked, but Hampton decided
  that HTML elements would be created with % like this:

%h1
  All Articles
Lastly, when an HTML element just has one line of content, we will
 conventionally put it on a single line:

%h1 All Articles
The % followed by the tag name will output any HTML tag. The content
 of that tag can be on the same line or indented on the following 
 lines. Note that content can’t both be inline with the tag and on
  the following lines.

Outputting Ruby in HAML

ERB method:

<p class='flash'><%= flash[:notice] %></p>
Given what you’ve seen from the H1, you would imagine the <p></p> 
becomes %p. But what about the Ruby injection?

Ruby Injections

HAML’s approach is to reduce <%= %> to just =. The HAML engine 
assumes that if the content starts with an =, that the entire rest
 of the line is Ruby. For example, the flash paragraph above would
  be rewritten like this:

%p= flash[:notice]
Note that the = must be flush against the %p tag.

Adding a CSS Class

But what about the class? There are two options. The verbose syntax
 uses a hash-like format:

%p{class: 'flash'}= flash[:notice]
But we can also use a CSS-like shorthand syntax:

%p.flash= flash[:notice]
The latter is easier and more commonly used.

Mixing Plain Text and Ruby

Consider a chunk of content that has both plain text and Ruby like
 this:

<div id="sidebar">
Filter by Tag: <%= tag_links(Tag.all) %>
</div>
Given what we’ve seen so far, you might imagine it goes like this:

%div#sidebar Filter by Tag: = tag_links(Tag.all)
But HAML won’t recognize the Ruby code there. Since the element’s
 content starts with plain text, it will assume the whole line is
  plain text.

Breaking Ruby and Text into Separate Lines

One solution in HAML is to put the plain text and the Ruby on their
 own lines, each indented under the DIV:

%div#sidebar
  Filter by Tag:
  = tag_links(Tag.all)
Since version 3, HAML supports an interpolation syntax for mixing
 plain text and Ruby:

%div#sidebar
  Filter by Tag: #{tag_links(Tag.all)}
And it can be pushed back up to one line:

%div#sidebar Filter by Tag: #{tag_links(Tag.all)}
Implicit DIV Tags

DIV is considered the "default" HTML tag. If you just use a CSS-style
 ID or Class with no explicit HTML element, HAML will assume a DIV:

#sidebar Filter by Tag: #{tag_links(Tag.all)}
Non-Printing Ruby

We’ve seen plain text, HTML elements, and printing Ruby. Now let’s focus
 on non-printing Ruby.

One of the most common uses of non-printing Ruby in a view template is
 iterating through a collection. In ERB we might have:

<ul id='articles'>
  <% @articles.each do |article| %>
    <li><%= article.title %></li>
  <% end %>
</ul>
The second and fourth lines are non-printing because they omit the
 equals sign. HAML’s done away with the <%. So you might be tempted
  to write this:

%ul#articles
  @articles.each do |article|
    %li= article.title
Content with no marker is interpreted as plain text, so the @articles
 line will be output as plain text and the third line would cause a
  parse error.

Marking Non-Printing Lines

We need a new symbol to mark non-printing lines. In HAML these lines
 begin with a hyphen (-):

%ul#articles
  - @articles.each do |article|
    %li= article.title
The end

Wait a minute, what about the end? HAML uses that significant whitespace
 to reduce the syntax of HTML and Ruby. The end for the do is not only
  unnecessary, it will raise an exception if you try to use it!

Review

The key ideas of HAML include:

Whitespace is significant, indent using two spaces
HTML elements are created with % and the tag name, ex: %p
HTML elements can specify a CSS class (%p.my_class) or ID (%p#my_id)
 using a short-hand syntax
Content starting with an = is interpreted as printing Ruby, 
ex: %p= article.title
Content starting with a - is interpreted as non-printing Ruby, 
ex: - @articles.each do |article|
Content can contain interpolation-style injections like 
%p Articles Available:#{@articles.count}