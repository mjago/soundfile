[![Build Status](https://travis-ci.org/mjago/soundfile.svg?branch=master)](https://travis-ci.org/mjago/CW)

# soundfile

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  soundfile:
    github: mjago/soundfile
```

## Usage

```crystal
require "soundfile"
```

### Read and write files

```crystal

SoundFile.open("read.wav", :read) do |sf_in|
  ptr = Slice.new(sf_in.size, Int32.new(0))
  sf.read_int(ptr, sf_in.size)

  SoundFile.open("write.wav", :write, sf_in.info) do |sf_out|
    sf_out.write_int(ptr, sf_in.size)
  end
end

```

## Dependencies
1. libsndfile

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/mjago/soundfile/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [mjago](https://github.com/mjago) mjago - creator, maintainer
