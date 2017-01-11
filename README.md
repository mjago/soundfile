[![Build Status](https://travis-ci.org/mjago/soundfile.svg?branch=master)](https://travis-ci.org/mjago/soundfile)

# soundfile

Crystal extension for the [libsndfile](http://www.mega-nerd.com/libsndfile/) _soundfile manipulation_ library

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
include SoundFile
```

### Read and write files

```crystal
SFile.open("read.wav", :read) do |sf_in|
  ptr = Slice.new(sf_in.size, Int32.new(0))
  sf.read_int(ptr, sf_in.size)

  SFile.open("write.wav", :write, sf_in.info) do |sf_out|
    sf_out.write_int(ptr, sf_in.size)
  end
end
```

See [specs](https://github.com/mjago/soundfile/blob/master/spec/soundfile_spec.cr) and [libsndfile](http://www.mega-nerd.com/libsndfile/) for further usage

## Dependencies
1. [libsndfile](http://www.mega-nerd.com/libsndfile/)

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/mjago/soundfile/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [mjago](https://github.com/mjago) - creator, maintainer
