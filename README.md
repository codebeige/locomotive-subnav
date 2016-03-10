# locomotive-subnav

Provide your LocomotiveCMS site with a context aware set of nested navigation
links that represent the currently selected branch of the page. Typical use
cases are a subnavigation inside a sidebar or breadcrumbs.

## Installation

Add a dependency to the Gemfile of *both* your Wagon site and the Locomotive
Rails application.

```ruby
gem 'locomotive-subnav'
```

## Usage

Put the following Liquid tags inside any of your Wagon template files:

### breadcrumbs

For a simple breadcrumb trail use the `breadcrumbs` tag.

```liquid
{% breadcrumbs (<options>) %}
```

##### Options

| Name    | Type      | Description                               | Default |
| ---     | ---       | ---                                       | ---     |
| `level` | `Integer` | Show ancestors including specified level. | `0`     |

##### Example

```liquid
{% breadcrumbs level: 1 %}
```

### subnav

For a subtree navigation that will also display the siblings of ancestors use
the `subnav` tag.

```liquid
{% subnav (<options>) %}
```

##### Options

| Name       | Type                               | Description                                    | Default |
| ---        | ---                                | ---                                            | ---     |
| `level`    | `Integer`                          | Show ancestor trail including specified level. | `0`     |
| `collapse` | `Integer` or `Array` of `Integer`s | Only show selected item on given level(s).     | `[]`    |

##### Example

```liquid
{% subnav level: 1, collapse: 1 %}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/codebeige/locomotive-subnav. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
