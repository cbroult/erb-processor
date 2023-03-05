# ERB::Processor

[![Test er-processor](https://github.com/cbroult/erb-processor/actions/workflows/main.yml/badge.svg)](https://github.com/cbroult/erb-processor/actions/workflows/main.yml)

Allows for the processing of all `.erb` files in a directory tree.

All `.erb` files in the specified directory tree are going to be
evaluated and the corresponding files without the `.erb` extension are
going to be written.


## Installation

    $ gem install erb-processor

## Usage

    $ erb-processor path/directory/tree/to/process

or

    $ cd path/directory/tree/to/process
    $ erb-processor .

The list of options is available with:

    $ erb-processor --help

## Template Content

### Auto Generated Header

The processed file can automatically include a warning that invites
the editing of the template by using the following in the template:
```ruby
<%= erb_processor.commented_processed_header %>
```

### A Template Example

Here is a template example for some Java code:

```java
<%= erb_processor.commented_processed_header %>

<% SCENARIOS_PENDING_AUTOMATION = 4 -%>

// The purpose of this class is to make the tests pending automation
// explicitely visible in the CI/CD report.
// The list of actual tests pending automation can be found at
// https://...
public class PendingTestAutomation {

<% SCENARIOS_PENDING_AUTOMATION.times do |i| 
     scenario_id = i + 1
-%>
  @Test(enabled=false)
  @Description("Test <%= scenario_id %>/<%= SCENARIOS_PENDING_AUTOMATION %> that is pending automation")
  public void toBeAutomated_<%= scenario_id %>_of_<%= SCENARIOS_PENDING_AUTOMATION %>(){}

<% end -%>
}
```

### Template Processing and ERB Processor Behavior

See the [`features/*.feature`](features) files for the expected behavior depending on the template content.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cbroult/erb-processor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cbroult/erb-processor/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ERB::Processor project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cbroult/erb-processor/blob/master/CODE_OF_CONDUCT.md).
