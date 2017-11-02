# United States Power Squadrons® Flag Generator

[![Gem Version](https://img.shields.io/gem/v/usps_flags.svg)](https://rubygems.org/gems/usps_flags)
[![Build Status](https://travis-ci.org/jfiander/usps-flags.svg)](https://travis-ci.org/jfiander/usps-flags)
[![Coverage Status](https://coveralls.io/repos/github/jfiander/usps-flags/badge.svg?branch=master&service=github)](https://coveralls.io/github/jfiander/usps-flags?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/760b824f0edac3316a11/maintainability)](https://codeclimate.com/github/jfiander/usps-flags/maintainability)

This gem allows you to generate precise SVG and PNG flag images based on official specifications.

## Installation

### Rails

Add to your Gemfile:
```ruby
gem 'usps_flags'
```

Create the file `config/initializers/usps_flags.rb`:
```ruby
USPSFlags::Config.flags_dir "#{Rails.root}/app/assets/images/flags"
```

### Other

Run `gem install usps_flags`.

Run `require 'usps_flags'` then `USPSFlags::Config.flags_dir "path/to/flags/dir"` to specify where to output all generated files and logs. (Otherwise, will default to `/output` in the gem directory.)

## Available flags

- US Ensign
- USPS Ensign
- USPS Ensign Wheel logo
- Officer flags
- Officer insignia
- Official pennants

## Testing

Tests are written in Rspec. To run all specs in a cloned repo, run 'rake'.

## Generation

### All files

To generate all static files, run:
```ruby
USPSFlags::Generate.all svg: true, png: true, zips: true
```

- Boolean arguments specify whether to process that set of files.

### Zip archives

To re-generate zip files from current static files, run:
```ruby
USPSFlags::Generate.zips svg: true, png: true
```

- Boolean arguments specify whether to process that set of files.

### Individual files

To generate an individual SVG file, run:
```ruby
USPSFlags::Generate.get "flag", outfile: nil, scale: nil, field: true
```

- `outfile` specifies where to save the file. If left as `nil`, this method will `puts` the generated SVG. Either way, the SVG code is returned.
- `scale` is a divisor scaling factor – the larger it is, the smaller the resulting SVG will be rendered. Accepted values are floats between 0 and 1, and integers above that.
- `field` specifies whether to render the field of a flag, or to only render the insignia. Setting this to `false` will invert some colors for visibility.

### Trident spec sheet

To generate the trident spec sheet, run:
```ruby
USPSFlags::Generate.spec outfile: nil, scale: nil, fly: 24, unit: "in"
```

- `outfile` specifies where to save the file. If left as `nil`, this method will `puts` the generated SVG. Either way, the SVG code is returned.
- `scale` is a divisor scaling factor – the larger it is, the smaller the resulting SVG will be rendered. Accepted values are floats between 0 and 1, and integers above that.
- `fly` specifies the custom fly measurement to scale all trident labels to.
- `unit` specifies the custom fly measurement unit to append to all trident labels.

### Convert SVG to PNG

To convert SVG data to a PNG image, run:
```ruby
USPSFlags::Generate.png svg_data, outfile: nil, trim: false

# USPSFlags::Generate.png File.read("path/to/svg_image.svg"), outfile: "path/to/output.png", trim: false
# USPSFlags::Generate.png USPSFlags::Generate.get("LtC"), outfile: "path/to/output.png", trim: true
```

- `outfile` is required, and specifies where to save the file.
- `trim` specifies whether to trim blank space from around the image. (This is ideal for generating insignia.)

## Constructing

You can also construct individual flags using the following syntax:

```ruby
f = USPSFlags.new do
  type "LtC"
  scale 3
  field false
  trim true
  svg_file "/path/to/svg/output.svg"
  png_file "/path/to/png/output.png"
end

f.svg # Generate SVG file
f.png # Generate PNG file
```

- Calling any DSL method without argument, or with `nil` as argument will return the current value.
- You can explicitly set `svg_file` to `""` to suppress printing the SVG content to console/log.
- Calling `.png` requires `png_file` to be set.

## Security

This gem is cryptographically signed. To be sure the gem code hasn’t been tampered with:

Add my public key as a trusted certificate:

```sh
gem cert --add <(curl -Ls https://raw.github.com/jfiander/usps-flags/master/certs/jfiander.pem)
```

Then install the gem securely:

```sh
gem install usps_flags -P HighSecurity
```

## License

Actual images generated (other than the US Ensign) are [registered trademarks](http://www.usps.org/national/itcom/trademark.html) of United States Power Squadrons.

This project is released under the [GPLv3](https://raw.github.com/jfiander/usps-flags/master/LICENSE).
