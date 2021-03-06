# United States Power Squadrons® Flag Generator

[![Gem Version](https://img.shields.io/gem/v/usps_flags.svg)](https://rubygems.org/gems/usps_flags)
[![Build Status](https://img.shields.io/travis/jfiander/usps-flags/master.svg)](https://travis-ci.org/jfiander/usps-flags)
[![Test Coverage](https://api.codeclimate.com/v1/badges/760b824f0edac3316a11/test_coverage)](https://codeclimate.com/github/jfiander/usps-flags/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/760b824f0edac3316a11/maintainability)](https://codeclimate.com/github/jfiander/usps-flags/maintainability)

This gem allows you to generate precise SVG and PNG flag images based on
official specifications.

## Installation

### Rails

Add to your Gemfile:

```ruby
gem 'usps_flags'
```

Create the file `config/initializers/usps_flags.rb`:

```ruby
USPSFlags.configure do |config|
  config.flags_dir = "#{Rails.root}/app/assets/images/flags"
end
```

## Available flags

- US Ensign
- USPS Ensign
- USPS Ensign Wheel logo
- Officer flags
- Officer insignia
- Official pennants

## Testing

Tests are written in Rspec.

To run all specs, run `rake` or `rspec`.

To run most specs, but skip the static file generators (which can be slow), run
`rspec --tag '~slow'`.

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
USPSFlags::Generate.svg "flag", outfile: nil, scale: nil, field: true
```

- `outfile` specifies where to save the file. If left as `nil`, this method will
  `puts` the generated SVG. Either way, the SVG code is returned.
- `scale` is a divisor scaling factor – the larger it is, the smaller the
  resulting SVG will be rendered. Accepted values are floats between 0 and 1,
  and integers above that.
- `field` specifies whether to render the field of a flag, or to only render the
  insignia. Setting this to `false` will invert some colors for visibility.

### Trident spec sheet

To generate the trident spec sheet, run:

```ruby
USPSFlags::Generate.spec outfile: nil, scale: nil, fly: 24, unit: "in"
```

- `outfile` specifies where to save the file. If left as `nil`, this method will
  `puts` the generated SVG. Either way, the SVG code is returned.
- `scale` is a divisor scaling factor – the larger it is, the smaller the
  resulting SVG will be rendered. Accepted values are floats between 0 and 1,
  and integers above that.
- `fly` specifies the custom fly measurement to scale all trident labels to.
- `unit` specifies the custom fly measurement unit to append to all trident
  labels.

### Convert SVG to PNG

To convert SVG data to a PNG image, run:

```ruby
USPSFlags::Generate.png svg_data, outfile: nil, trim: false
```

- `outfile` is required, and specifies where to save the file.
- `trim` specifies whether to trim blank space from around the image. (This is
  ideal for generating insignia.)

## Constructing

You can also construct individual flags using the following syntax:

```ruby
flag = USPSFlags.new do |f|
  f.type = "LtC"
  f.scale = 3
  f.field = false
  f.trim = true
  f.svg_file = "/path/to/svg/output.svg"
  f.png_file = "/path/to/png/output.png"
end

flag = USPSFlags.new(
  type: "LtC", scale: 3, field: false, trim: true,
  svg_file: "/path/to/svg/output.svg",
  png_file: "/path/to/png/output.png"
)

flag.svg #=> Generates SVG file at "/path/to/svg/output.svg"
flag.png #=> Generates PNG file at "/path/to/png/output.png"
```

- You can explicitly set `svg_file` to `""` to suppress printing the SVG content
  to console/log.
- Calling `.png` requires `png_file` to be set.

## Extensions

There is an extension to this gem for handling squadron burgees:
[USPSFlags::Burgees](https://github.com/jfiander/usps-flags_burgees)

There is an extension to this gem for handling grade insignia:
[USPSFlags::Grades](https://github.com/jfiander/usps-flags_grades)

## License

Actual images generated (other than the US Ensign) are
[registered trademarks](https://www.usps.org/images/secretary/itcom/trademark.pdf) of
United States Power Squadrons.

This project is released under the
[GPLv3](https://raw.github.com/jfiander/usps-flags/master/LICENSE).
