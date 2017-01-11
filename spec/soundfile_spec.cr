require "./spec_helper"
require "tempfile"
require "./../../soundfile/src/soundfile.cr"

include SoundFile

describe SFile do
  a = SFile.new
  test_wav = "spec/data/wave.wav"
  short = Array(Int16).new
  int = Array(Int32).new
  float = Array(Float32).new
  double = Array(Float64).new

  it "is a Class" do
    SFile.is_a?(Class).should eq(true)
  end

  it "instantiates a new SFile class when passed no arguments" do
    a.class.should eq(SFile)
  end

  it "can be passed a LibSndFile::SFInfo object on instantiation" do
    b = SFile.new(a.info)
    b.class.should eq(SFile)
    b.info.should eq(a.info)
    b.info.class.should eq(SFile.info.class)
    b.close

    info = SFile.info
    b = SFile.new(info)
    b.class.should eq(SFile)
    b.info.should eq(a.info)
    b.close
  end

  describe "#open" do
    it "returns false when opening a non-existing file for read" do
      a.open("invalid.wav", :read).should eq false
      a.close
    end

    it "returns true when opening a valid file for read" do
      a.open(test_wav, :read).should be_true
      a.close
    end

    it "returns true when opening a valid file for read/write" do
      a.open(test_wav, :rd_wr).should be_true
      a.close
    end

    it "can be invoked with a block" do
      a.open("test_wav", :read) do |sf|
        sf.class.should eq SFile
        sf.info.class.should eq SFile.info.class
      end
    end

    #    it "returns true when opening a file for write" do
    #      a.open(test_wav, :write).should be_true
    #      a.close
    #    end
  end

  describe "#close" do
    it "returns true if file closed" do
      a.open(test_wav, :read).should be_true
      a.close.should eq 0
    end
  end

  describe "#open_fd" do
    File.open(test_wav, "r") do |f|
      it "can open a file given a file descriptor" do
        a.open_fd(f.fd, :read).should be_true
        a.close
      end

      it "can be invoked with a block" do
        a.open_fd(f.fd, :read) do |sf|
          sf.class.should eq SFile
          sf.info.class.should eq SFile.info.class
        end
      end
    end
  end

  describe "#open_file" do
    File.open(test_wav, "r") do |f|
      it "can open a file given a file object" do
        a.open_file(f, :read).should be_true
        a.close
      end
    end

    File.open(test_wav, "r") do |f|
      it "can be invoked with a block" do
        a.open_file(f, :read) do |sf|
          sf.class.should eq SFile
          sf.info.class.should eq SFile.info.class
        end
      end
    end
  end

  describe "@open" do
    it "can call open on SFile" do
      SFile.open(test_wav, :read) do |sf|
        sf.error_number.should eq 0
        sf.class.should eq SFile
        sf.info.class.should eq SFile.info.class
        ptr = Slice.new(sf.size, Int32.new(0))
        sf.read_int(ptr, sf.size).should eq sf.size
        SFile.open("spec/data/write5.wav", :write, sf.info) do |sf_out|
          sf.size
          sf_out.write_int(ptr, sf.size)
          sf.error_to_s
        end
      end
    end
  end

  describe "self.open" do
    it "can be invoked with a block" do
      SFile.open(test_wav, :read) do |sf|
        sf.error_number.should eq 0
        sf.size.should eq 256_000
        ptr = Slice.new(sf.size, Int32.new(0))
        sf.read_int(ptr, sf.size).should eq sf.size
        SFile.open("spec/data/write5.wav", :write, sf.info) do |sf_out|
          sf.error_number.should eq 0
          sf.size.should eq sf.size
          size = sf_out.write_int(ptr, sf.size)
          size.should eq 256_000
        end
      end
    end
  end

  describe "#set_string/get_string" do
    it "can write meta data to a file open for write" do
      info = SFile.info
      info.format = 0x10002
      info.channels = 2
      info.samplerate = 44_100
      sf = SFile.new(info)
      sf.open("spec/data/write.wav", :write)
      sf.error_number.should eq 0
      sf.set_string("My Title", "title")
      sf.get_string("title").should eq "My Title"
      sf.get_string("title").should eq "My Title"
      sf.close

      info = SFile.info
      info.format = 0x10002
      info.channels = 2
      info.samplerate = 44_100
      sf = SFile.new(info)
      sf.open("spec/data/write.wav", :write) do |sf|
        sf.get_string("title").should eq ""
        sf.set_string("My Title", "title")
        sf.get_string("title").should eq "My Title"
        sf["title"].should eq "My Title"
      end

      info = SFile.info
      info.format = 0x10002
      info.channels = 2
      info.samplerate = 44_100
      SFile.open("spec/data/write.wav", :write, info) do |sf|
        sf.error_number.should eq 0
        sf.get_string("title").should eq ""
        sf.set_string("My Title", "title")
        sf.get_string("title").should eq "My Title"
        sf["title"].should eq "My Title"
      end
    end
  end

  describe "#set_string/get_string" do
    it "can write meta data to a file open for write" do
      File.open("spec/data/write3.wav", "w") do |f|
        info = SFile.info
        info.format = 0x10002
        info.channels = 2
        info.samplerate = 44_100
        b = SFile.new(info)
        b.open_file(f, :write) # .should be_true
        b.error_number.should eq 0
        b.get_string("title").should eq ""
        b.set_string("My Title", "title")
        b.get_string("title").should eq "My Title"
        b["title"].should eq "My Title"
        b.close
      end
    end
  end

  describe "#[]" do
    it "can write meta data to a file open for write" do
      info = SFile.info
      info.format = 0x10002
      info.channels = 2
      info.samplerate = 44_100
      File.open("spec/data/write.wav", "w") do |f|
        a.info = info
        a.open_file(f, :write) do |fs|
          fs["album"] = "My Album"
          fs["album"].should eq "My Album"
        end
      end
    end
  end

  describe "#read_raw" do
    it "can return read a soundfile as raw data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, UInt8.new(0))
      a.read_raw(ptr, a.size).should eq a.size
      ptr[10000].should eq(ptr[10002])
      ptr[10001].should eq(ptr[10003])
      ptr[10000].should eq(214)
      ptr[10001].should eq(254)
      a.close
    end
  end

  describe "#read_short" do
    it "can return read a soundfile as 16 bit data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Int16.new(0))
      a.read_short(ptr, a.size).should eq a.size
      ptr[10000].should eq(ptr[10001])
      ptr[10002].should eq(ptr[10003])
      ptr[10000].should eq(169)
      ptr[10002].should eq(78)
      short << ptr[10000]
      short << ptr[10002]
      a.close
    end
  end

  describe "#read_int" do
    it "can return read a soundfile as 32 bit data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Int32.new(0))
      a.read_int(ptr, a.size).should eq a.size
      ptr[10000].should eq(ptr[10001])
      ptr[10002].should eq(ptr[10003])
      int << ptr[10000]
      int << ptr[10002]
      short[0].should eq int[0] / 0x10000
      short[1].should eq int[1] / 0x10000
      a.close
    end
  end

  describe "#read_float" do
    it "can return read a soundfile as 32 bit float data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Float32.new(0))
      a.read_float(ptr, a.size).should eq a.size
      ptr[10000].should eq(ptr[10001])
      ptr[10002].should eq(ptr[10003])
      float << ptr[10000]
      float << ptr[10002]
      a.close
    end
  end

  describe "#read_double" do
    it "can return read a soundfile as 32 bit double data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Float64.new(0))
      a.read_double(ptr, a.size).should eq a.size
      ptr[10000].should eq(ptr[10001])
      ptr[10002].should eq(ptr[10003])
      double << ptr[10000]
      double << ptr[10002]
      float[0].should eq double[0]
      float[1].should eq double[1]
      a.close
    end
  end

  describe "#readf_short" do
    it "can return read a soundfile as 16 bit data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Int16.new(0))
      a.readf_short(ptr, a.frames).should eq a.frames
      ptr[10000].should eq(ptr[10001])
      ptr[10002].should eq(ptr[10003])
      ptr[10000].should eq short[0]
      ptr[10002].should eq short[1]
      a.close
    end
  end

  describe "#readf_int" do
    it "can return read a soundfile as 32 bit data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Int32.new(0))
      a.readf_int(ptr, a.frames).should eq a.frames
      ptr[10000].should eq int[0]
      ptr[10002].should eq int[1]
      a.close
    end
  end

  describe "#readf_float" do
    it "can return read a soundfile as 32 bit float data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Float32.new(0))
      a.readf_float(ptr, a.frames).should eq a.frames
      ptr[10000].should eq float[0]
      ptr[10002].should eq float[1]
      a.close
    end
  end

  describe "#readf_double" do
    it "can return read a soundfile as 32 bit double data" do
      a.open(test_wav, :read)
      ptr = Slice.new(a.size, Float64.new(0))
      a.readf_double(ptr, a.frames).should eq a.frames
      ptr[10000].should eq double[0]
      ptr[10002].should eq double[1]
      a.close
    end
  end

  describe "#seek" do
    it "can seek within a soundfile" do
      a.open(test_wav, :read)
      ptr = Slice.new(4, Int32.new(0))
      a.seek(5000, "seek_set")
      a.readf_int(ptr, 4).should eq 4
      ptr[0].should eq int[0]
      ptr[2].should eq int[1]
      a.close
    end
  end

  describe "#error_number" do
    it "returns an error number on error" do
      a.open("invalid.wav", :read)
      a.error_number.should eq 2
      a.close
    end
  end

  describe "#error_number" do
    it "returns 0 on no error" do
      a.open(test_wav, :read)
      a.error_number.should eq 0
      a.close
    end
  end

  describe "#error_to_s" do
    it "returns an error description on error" do
      a.open("invalid.wav", :read)
      a.error_to_s.should eq "System error."
      a.close
    end
  end

  describe "#error_to_s" do
    it "returns an No Error. on no error" do
      a.open(test_wav, :read)
      a.error_to_s.should eq "No Error."
      a.close
    end
  end

  describe "#no_error?" do
    it "returns true if no error" do
      a.open(test_wav, :read)
      a.no_error?.should be_true
      a.close
    end

    it "returns false if error" do
      a.open("invalid.wav", :read)
      a.no_error?.should be_false
      a.close
    end
  end

  describe "#format_check" do
    it "returns true if format check ok" do
      a.format_check.should be_true
      a.close
    end
  end

  describe "#format_check" do
    it "returns false if format invalid" do
      a.info.format = 0
      a.format_check.should be_false
      a.info.format = (LibSndFile::Formats::WAV.value |
                       LibSndFile::Subtypes::PCM_16.value |
                       LibSndFile::Endians::FILE.value)
      a.format_check.should be_true
      a.close
    end
  end

  describe "format_raw" do
    it "returns raw format info" do
      a.open(test_wav, :read)
      a.format_raw.to_s(16).should eq "10002"
      a.close
    end
  end

  describe "sub_type" do
    it "returns sub type" do
      a.open(test_wav, :read)
      a.sub_type.should eq "PCM_16"
      a.close
    end
  end

  describe "format_type" do
    it "returns sub type" do
      a.open(test_wav, :read)
      a.format_type.should eq "WAV"
      a.close
    end
  end

  describe "endian_type" do
    it "returns endian type" do
      a.open(test_wav, :read)
      a.endian_type.should eq "FILE"
      a.close
    end
  end

  describe "format_to_hash" do
    it "returns format as a hash" do
      a.open(test_wav, :read)
      a.format_to_hash.should eq({"subtype" => "PCM_16",
        "format"  => "WAV",
        "endian"  => "FILE"})
      a.close
    end
  end

  describe "format_to_tuple" do
    it "returns format as a tuple" do
      a.open(test_wav, :read)
      a.format_to_tuple.should eq({"PCM_16", "WAV", "FILE"})
      a.close
    end
  end

  describe "format_to_s" do
    it "returns format as a formatted string" do
      a.open(test_wav, :read)
      a.format_to_s.should eq("Format: WAV, Subtype: PCM_16, Endian: FILE")
      a.close
    end
  end

  describe "sample_rate" do
    it "returns sample rate" do
      a.open(test_wav, :read)
      a.sample_rate.should eq 44_100
      a.close
    end
  end

  describe "frames" do
    it "returns number of frames" do
      a.open(test_wav, :read)
      a.frames.should eq 128_000
      a.close
    end
  end

  describe "channels" do
    it "returns number of channels" do
      a.open(test_wav, :read)
      a.channels.should eq 2
      a.close
    end
  end

  describe "sections" do
    it "returns number of sections" do
      a.open(test_wav, :read)
      a.sections.should eq 2
      a.close
    end
  end

  describe "seekable?" do
    it "returns number of seekable" do
      SFile.open(test_wav, :read) do |sf|
        sf.seekable?.should be_true
        sf.close
      end
    end
  end

  describe "size" do
    it "returns size (frames * channels)" do
      SFile.open(test_wav, :read) do |sf|
        sf.size.should eq 256_000
        sf.close
      end
    end
  end

  describe "sf_version" do
    it "returns libsndfile version" do
      a.open(test_wav, :read)
      a.sf_version.should contain "libsndfile-1."
      a.close
    end
  end

  describe "version" do
    it "returns SoundFile version" do
      a.version.should be "0.1.0"
      a.close
    end
  end

  describe "#get_log_info" do
    it "returns log info string" do
      SFile.open("invalid.wav", :read, a.info) do |outfile|
        outfile.get_log_info.should eq "File : invalid.wav\n"
      end
      a.close
    end
  end

  describe "#calc_signal_max" do
    it "calculates the measured maximum signal value" do
      SFile.open(test_wav, :read) do |sf|
        sf.calc_signal_max.should eq 9357.0
        sf.close
      end
    end
  end

  describe "#calc_norm_signal_max" do
    it "calculates the measured normalised maximum signal value" do
      SFile.open(test_wav, :read) do |sf|
        sf.calc_norm_signal_max.should eq 0.285552978515625
        sf.close
      end
    end
  end

  describe "#calc_max_all_channels" do
    it "calculates the peak value for each channel" do
      a.open(test_wav, :read)
      a.calc_max_all_channels.should eq [9357.0, 9357.0]
      a.close
    end
  end

  describe "#calc_norm_max_all_channels" do
    it "calculates the normalised peak for each channel" do
      a.open(test_wav, :read)
      a.calc_norm_max_all_channels.should eq [0.285552978515625, 0.285552978515625]
      a.close
    end
  end

  describe "#get_signal_max" do
    it "retrieves the peak value for the file (as stored in the file header)" do
      a.open(test_wav, :read)
      a.get_signal_max.should be_nil
      a.close
    end
  end

  describe "#get_max_all_channels" do
    it "retrieves the peak value for each channel (as stored in the file header)" do
      a.open(test_wav, :read)
      a.get_max_all_channels.should be_nil
      a.close
    end
  end

  describe "#set_norm_float" do
    it "modifies the normalisation behaviour of the floating point reading and writing functions" do
      a.open(test_wav, :read)
      a.set_norm_float(:true).should eq 1
      a.get_norm_float.should eq 1
      a.set_norm_float(:false).should eq 1
      a.get_norm_float.should eq 0
      a.close
    end
  end

  describe "#set_norm_double" do
    it "modifies the normalisation behaviour of the double floating point reading and writing functions" do
      a.open(test_wav, :read)
      a.set_norm_double(:true).should eq 1
      a.get_norm_double.should eq 1
      a.set_norm_double(:false).should eq 1
      a.get_norm_double.should eq 0
      a.close
    end
  end

  describe "#set_scale_float_int_read" do
    it "Sets/clears the scale factor when integer (short/int) data is read from a file containing floating point data" do
      a.open(test_wav, :read)
      a.set_scale_float_int_read(:true).should eq 0
      a.set_scale_float_int_read(:false).should eq 1
      a.close
    end
  end

  describe "#get_simple_format_count" do
    it "retrieves the number of simple formats supported" do
      a.open(test_wav, :read)
      a.get_simple_format_count.should eq 14
      a.close
    end
  end

  describe "#get_simple_format" do
    it "retrieves information about a simple format" do
      a.open(test_wav, :read)
      sf = a.get_simple_format
      sf.class.should eq LibSndFile::SFFormatInfo
      sf.not_nil!.format.should eq 0x10002
      String.new(sf.not_nil!.extension).should eq "wav"
      String.new(sf.not_nil!.name).should eq "WAV (Microsoft 16 bit PCM)"
      a.close
    end
  end

  describe "#get_format_info" do
    it "retrieves info about a major format" do
      finfo = SFile.format_info
      finfo.format = (LibSndFile::Formats::WAV.value)
      finfo = a.get_format_info(finfo)
      String.new(finfo.name).should eq "WAV (Microsoft)"
      String.new(finfo.extension).should eq "wav"
      finfo.format.to_s(16).should eq "10000"
      finfo.format = (LibSndFile::Formats::WAV.value)
    end

    it "retrieves info about a subtype format" do
      finfo = SFile.format_info
      finfo.format = (LibSndFile::Subtypes::PCM_16.value)
      finfo = a.get_format_info(finfo)
      String.new(finfo.name).should eq "Signed 16 bit PCM"
      finfo.format.to_s(16).should eq "2"
    end
  end

  describe "#get_format_major_count" do
    it "retrieves the number of major formats" do
      a.get_format_major_count.should eq 25
      a.close
    end
  end

  describe "#get_format_major" do
    it "retrieves the number of major formats" do
      finfo = SFile.format_info
      finfo.format = (LibSndFile::Formats::WAV.value)
      finfo = a.get_format_info(finfo)
      fmt = a.get_format_major(finfo)
      String.new(finfo.name).should eq "WAV (Microsoft)"
      String.new(finfo.extension).should eq "wav"
      finfo.format.to_s(16).should eq "10000"
      a.close
    end
  end

  describe "#get_format_subtype_count" do
    it "retrieves the number of major formats" do
      a.get_format_subtype_count.should eq 21
      a.close
    end
  end

#      puts String.new(finfo.name)
#      puts String.new(finfo.extension)
#      puts finfo.format.to_s(16)

  describe "#set_add_peak_chunk" do
    pending "" do
    end
  end

  describe "#update_header_now" do
    pending "" do
      cmd = LibSndFile::Command::SFC_UPDATE_HEADER_NOW
      LibSndFile.command(@handle, cmd, nil, 0)
    end
  end

  describe "#set_update_header_auto(val)" do
    pending "" do
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_UPDATE_HEADER_AUTO
      LibSndFile.command(@handle, cmd, nil, true_false)
    end
  end

  describe "#file_truncate(frames : Int32)" do
    pending "" do
    end
  end

  describe "#set_raw_start_offset(frames : Int32)" do
    pending "" do
    end
  end

  describe "#set_clipping(val)" do
    pending "" do
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_CLIPPING
      LibSndFile.command(@handle, cmd, nil, true_false)
    end
  end

  describe "#get_clipping" do
    pending "" do
      cmd = LibSndFile::Command::SFC_GET_CLIPPING
      LibSndFile.command(@handle, cmd, nil, 0)
    end
  end

  describe "#get_embed_file_info" do
    pending "" do
      data = LibSndFile::SFEmbedFileInfo.new
      ptr = pointerof(data)
      cmd = LibSndFile::Command::SFC_GET_EMBED_FILE_INFO
      LibSndFile.command(@handle, cmd, ptr, sizeof(LibSndFile::SFEmbedFileInfo))
    end
  end

  describe "#wavex_get_ambisonic" do
    pending "" do
      cmd = LibSndFile::Command::SFC_WAVEX_GET_AMBISONIC
      res = LibSndFile.command(@handle, cmd, nil, 0)
      return "SF_AMBISONIC_NONE" if res == LibSndFile::Ambisonic::SF_AMBISONIC_NONE.value
      return "SF_AMBISONIC_B_FORMAT" if res == LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT.value
      res.to_s(16)
    end
  end

  describe "#wavex_set_ambisonic(ambi)" do
    pending "" do
      val = LibSndFile::Ambisonic::SF_AMBISONIC_NONE
      val = LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT if ambi == :b_format
      cmd = LibSndFile::Command::SFC_WAVEX_SET_AMBISONIC
      res = LibSndFile.command(@handle, cmd, nil, val.value)
      return "SF_AMBISONIC_NONE" if res == LibSndFile::Ambisonic::SF_AMBISONIC_NONE.value
      return "SF_AMBISONIC_B_FORMAT" if res == LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT.value
      res
    end
  end

  describe "#set_vbr_encoding_quality(quality : Float64)" do
    pending "" do
      if (quality < 0.0) || (quality > 1.0)
        raise "Error: Invalid vbr encoding quality"
      end
      quality_ptr = pointerof(quality)
      cmd = LibSndFile::Command::SFC_SET_VBR_ENCODING_QUALITY
      LibSndFile.command(@handle, cmd, quality_ptr, sizeof(Float64))
    end
  end

  describe "#set_compression_level(level : Float64)" do
    pending "" do
      if (level < 0.0) || (level > 1.0)
        raise "Error: Invalid compression level"
      end
      level_ptr = pointerof(level)
      cmd = LibSndFile::Command::SFC_SET_COMPRESSION_LEVEL
      LibSndFile.command(@handle, cmd, level_ptr, sizeof(Float64))
    end
  end

  describe "#raw_data_needs_endswap" do
    pending "" do
      cmd = LibSndFile::Command::SFC_RAW_DATA_NEEDS_ENDSWAP
      LibSndFile.command(@handle, cmd, nil, 0)
    end
  end

  describe "#get_broadcast_info" do
    pending "" do
      # SFC_GET_BROADCAST_INFO         = 0x10F0
      raise " not yet implemented!"
    end
  end

  describe "#set_broadcast_info" do
    pending "" do
      # todo
      #    SFC_SET_BROADCAST_INFO         = 0x10F0
      raise "get_broadcast_info not yet implemented!"
    end
  end

  describe "#set_cart_info" do
    pending "" do
      # todo
      # SFC_SET_CART_INFO	Set the Cart Chunk info
      raise "set_cart_info not yet implemented!"
    end
  end

  describe "#get_cart_info" do
    pending "" do
      # todo
      # SFC_GET_CART_INFO	Retrieve the Cart Chunk info
      raise "get_cart_info not yet implemented!"
    end
  end

  describe "#get_loop_info" do
    pending "" do
      # GET_LOOP_INFO	Get loop info
      raise " not yet implemented!"
    end
  end

  describe "#get_instrument" do
    pending "" do
      # todo
      # SFC_GET_INSTRUMENT	Get instrument info
      raise "get_loop_info not yet implemented!"
    end
  end

  describe "#set_instrument" do
    pending "" do
      # todo
      # SFC_SET_INSTRUMENT	Set instrument info
      raise "set_instrument not yet implemented!"
    end
  end

  describe "#get_cue_count" do
    pending "" do
      count = UInt32.new(0)
      cmd = LibSndFile::Command::SFC_GET_CUE_COUNT
      res = LibSndFile.command(@handle, cmd, pointerof(count), sizeof(UInt32))
      raise "Error getting cue count" unless res == 0
      count
    end
  end

  describe "#get_cue" do
    pending "" do
      # SFC_GET_CUE	Get cue marker info
      raise "get_cue not yet implemented!"
    end
  end

  describe "#set_cue" do
    pending "" do
      # todo
      # SFC_SET_CUE	Set cue marker info
      raise "set_cue not yet implemented!"
    end
  end

  describe "#rf64_auto_downgrade(val)" do
    pending "" do
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_RF64_AUTO_DOWNGRADE
      LibSndFile.command(@handle, cmd, nil, true_false)
    end
  end
end

# describe Tempfile do
#  it "should have size 6" do
#    tempfile = Tempfile.open("foo") do |file|
#      path = file.path
#      path.should eq file.path
#      File.size(path).should eq 0
#      File.exists?(path).should be_true
#      puts File.read_lines(path).should eq [] of Char
#    end
#  end
# end

# File.size(tempfile.path)       # => 6
# File.stat(tempfile.path).mtime # => 2015-10-20 13:11:12 UTC
# File.exists?(tempfile.path)    # => true
# File.read(tempfile.path) # => ["foobar"]
# ```
#
# Files created from this class are stored in a directory that handles
# temporary files.
#
# ```
# Tempfile.new("foo").path # => "/tmp/foo.ulBCPS"
# ```
#
# Also, it is encouraged to delete a tempfile after using it, which
# ensures they are not left behind in your filesystem until garbage collected.
#
# ```
# tempfile = Tempfile.new("foo")
# tempfile.unlink
# ```
