# ContentPackRails

[![Gem Version](https://badge.fury.io/rb/content_pack_rails.svg)](https://badge.fury.io/rb/content_pack_rails)
[![Tests](https://github.com/a-bohush/content_pack_rails/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/a-bohush/content_pack_rails/actions/workflows/tests.yml)

A thin wrapper around [`ActionView::Helpers::CaptureHelper#content_for`](https://api.rubyonrails.org/classes/ActionView/Helpers/CaptureHelper.html#method-i-content_for).
Useful when you need to collect multiple content entries during page rendering, for example <script type="text/template"> templates, without woring about possible duplications and name clashes.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'content_pack_rails'
```

And then execute:
```bashn
$ bundle install
```

## Usage

Include `ContentPackRails` into your `ApplicationHelper`:
```ruby
module ApplicationHelper
    include ContentPackRails
end
```

By default, this will add three view helpers `content_pack`, `provide_content_pack` and `content_pack_get`.
To avoid collisions with a helper of the same name you might already have in your app, provide a different name:

```ruby
module ApplicationHelper
    # This will add custom_named_pack and provide_custom_named_pack helpers respectively.
    include ContentPackRails.init(pack_name: 'custom_named_pack')
end
```

Helper `content_pack` declares the same parameters as the standard rails `content_for` and can be used similarly to capture content like this:

```erb
<% content_pack 'content-id' do |id| %>
   <!--
     Your content goes here.
     Additionally, the content name is passed as the first parameter.
     So you may use it further, for example, to set it as the id attribute for an element.
       <div id=<%= id %>></div>
   -->
<% end %>
```
or pass content as the second argument:
```erb
<% content_pack 'content-id', 'Your content' %>
```

Unlike `content_for`, by default, `content_pack` will not concatenate content with the same name.
Multiple calls to `content_pack` with the same content name will result in only the first content being added to the pack.
If you would like to add additional content on a given name, you should pass the `append: true` option like so:

```erb
<% content_pack 'content-id', 'first content' %>
<!-- following will be concatenated with the first one -->
<% content_pack 'content-id', 'second content', append: true %>
```

In case you want to override content on a given name, provide the `flush: true` option:
```erb
<% content_pack 'content-id', 'first content' %>
<!-- following will override the first one -->
<% content_pack 'content-id', 'second content', flush: true %>
```

Every content passed to the `content_pack` is aggregated into one "pack," which you can access through the correspondent `provide_content_pack` helper.
So later on, you can render the whole pack somewhere in your view, like this:
```erb
<%= provide_content_pack %>
```

To access a single content entry from the pack, use `content_pack_get`:
```erb
<%= content_pack_get('content-id') %>
```

Should you want to have multiple packs, for example, to group content, you can set up those by including this module as many times as needed with different names:
```ruby
module ApplicationHelper
    include ContentPackRails.init(pack_name: 'content_pack2')
    include ContentPackRails.init(pack_name: 'content_pack3')
    # etc.
end
```

### Common use-case example

You may have javascript components that render HTML using templates in the form of `<script type="text/template">`.
Those templates are usually included as a part of rendered HTML, and if you have enough of them, it is hard to track what has already been included.

Given that the same component may be a part of other components templates and so on, you may end up with multiple copies of the same template included in the final response.
`ContentPackRails` helpers tandem allow you to organize JS templates provisioning in a way somewhat similar to how it is done with javascript files.

For example, you can keep such templates as regular rails view partials in separate files somewhere under `app/views` directory:
```bash
# ...
app/views/comments/_collection_template.html.erb
app/views/comments/_item_template.html.erb
# ...
```
Both those templates can be exported using `content_pack` helper like this:
```erb
<!-- app/views/comments/_item_template.html.erb -->
<%= content_pack 'comments-item-template' do |id| %>
   <script type="text/template" id=<%= id %>>
      // item component template goes here
   </script>
<% end %>
```

```erb
<!-- app/views/comments/_collection_template.html.erb -->

<% render 'item_template' %>

<%= content_pack 'comments-collection-template' do |id| %>
   <script type="text/template" id=<%= id %>>
      // somewhere here you will likely loop through comments using <comments-item-component> with some properties
   </script>
<% end %>
```
Note that in `app/views/comments/_collection_template.html.erb` we called `render` for `item_template` because the collection template depends on it.
Calling `render` here may be thought of as `import` for the template, which in its turn tirgers `content_pack` (aka `export`) to include the template into a bundle.
Each template contains all the imports it depends on, so you can just grab any template and be sure its dependencies also end up in a final pack, like in the following example.

```erb
<!-- app/views/comments/index.html.erb -->

<% render 'collection_template' %> <!-- this will include collection and item templates -->

<!-- rest of the index.html -->
```

Resulting bundle of templates we can include in our `app/views/layouts/application.html.rb` like so:
```erb
<html>
  <head></head>
  <body>
    <%= yield %>
  </body>
  <%= provide_content_pack %>
</html>
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
