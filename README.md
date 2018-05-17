# Pillar

Pillar in a lightweight and flexible gem for sorting and paginating tables and lists.

- Lightweight:
  - Only ruby, no javascript
  - No dependecies except for rails
  - Only adds one method to your model
- Flexible
  - Can be include to both models and "view objects"
  - You can easily specify your ordering and pagination scopes, should work with almost every ORM
  - Replace labels and icons by overrighting default view helpers
  - Default values for ActiveRecord

## Installation

```ruby
gem 'pillar', :git => 'https://github.com/olojac/pillar.git'
```

## Usage

Include Pillar to the class you want to use. It dosn't need to be a model, pillar not depended on your models attributes.

Specify your sorting and paginating scopes:


```ruby
class MyModel < ApplicationRecord
  include Pillar

  pillar :sort,     param: :name
  pillar :sort,     param: :value
  pillar :sort,     param: :created_at
  pillar :sort,     param: :updated_at
  pillar :paginate, param: :page
    
  # ...
end
```

Augment you queries in your controller:

```ruby
class MyController < ApplicationController

  def index
    @query  = MyModel.all
    @pillar = MyModel.pillar
    @items  = @pillar.query(@query).with(:sort, :paginate, params)
    # @total_count = @query.count
  end

  # ...
end
```

Add helpers to your views:

```ruby
# sort link for updated_at
pillar_sort_link("Updated At", @pillar.updated_at)

# paginate link for prev/next buttons
pillar_paginate(@pillar.paginate)

# optional, add total number of elements to avoid displaying empty pages
pillar_paginate(@pillar.paginate, @total_count)
```

Customize labels and icons by overriding the following view helpers:

```ruby
# view helpers with default values

def pillar_sort_asc_icon
  "⯅"
end

def pillar_sort_desc_icon
  "⯆"
end

def pillar_paginate_next_label
  "Next ⯈"
end

def pillar_paginate_prev_label
  "⯇ Prev"
end
```

