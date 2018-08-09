# Pillar

Pillar in a lightweight and flexible gem for sorting and paginating tables and lists.

- Lightweight:
  - Only ruby, no javascript
  - Activesupport is the only dependecies
  - Only adds one method to your model
- Flexible
  - Can be included to any class
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

  pillar :sort,     :name
  pillar :sort,     :value
  pillar :sort,     :created_at
  pillar :sort,     :updated_at
  pillar :filter,   :search, on: [:name, :email]
  pillar :paginate, :page
    
  # ...
end
```

Augment you queries in your controller:

```ruby
class MyController < ApplicationController

  def index
    @query  = MyModel.all
    @pillar = MyModel.pillar
    @items  = @pillar.query(@query, params)
    # @total_count = @query.count
  end

  # ...
end
```

Add helpers to your views:

```ruby
# sort link for updated_at
pillar_sort_link(@pillar, :updated_at, "Updated At")

# paginate link for prev/next buttons
pillar_paginate(@pillar)

# optional, add total number of elements to avoid displaying empty pages
pillar_paginate(@pillar, @total_count)
```

Customize labels and icons by overriding the following view helpers:

```ruby
# view helpers with default values

pillar_sort_asc_icon       # default: "⯅"
pillar_sort_desc_icon      # default: "⯆"
pillar_paginate_next_label # default: "Next ⯈""
pillar_paginate_prev_label # default: "⯇ Prev"

# see lib/pillar/view_helpers for more
```

