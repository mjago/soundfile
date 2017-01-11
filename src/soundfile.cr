# coding: utf-8

require "./soundfile/*"

@[Link("sndfile")]
lib LibSndFile
  alias CChar = LibC::Char
  alias CShort = LibC::Int16T
  alias CInt = LibC::Int32T
  alias CUInt = LibC::UInt32T
  alias CLong = LibC::Int64T
  alias CULong = LibC::UInt64T
  alias CFloat = LibC::Float
  alias CDouble = LibC::Double
  alias SndFile = CInt
  alias CloseDesc = CInt
  alias SFCount = CLong

  enum TBool
    SF_FALSE = 0
    SF_TRUE  = 1
  end

  enum Mode : CInt
    READ  = 0x10,
    WRITE = 0x20,
    RDWR  = 0x30
  end

  enum StringType
    TITLE       = 1,
    COPYRIGHT,
    SOFTWARE,
    ARTIST,
    COMMENT,
    DATE,
    ALBUM,
    LICENSE,
    TRACKNUMBER,
    GENRE
  end

  enum Formats
    WAV   = 0x010000,
    AIFF  = 0x020000,
    AU    = 0x030000,
    RAW   = 0x040000,
    PAF   = 0x050000,
    SVX   = 0x060000,
    NIST  = 0x070000,
    VOC   = 0x080000,
    IRCAM = 0x0A0000,
    W64   = 0x0B0000,
    MAT4  = 0x0C0000,
    MAT5  = 0x0D0000,
    PVF   = 0x0E0000,
    XI    = 0x0F0000,
    HTK   = 0x100000,
    SDS   = 0x110000,
    AVR   = 0x120000,
    WAVEX = 0x130000,
    SD2   = 0x160000,
    FLAC  = 0x170000,
    CAF   = 0x180000,
    WVE   = 0x190000,
    OGG   = 0x200000,
    MPC2K = 0x210000,
    RF64  = 0x220000
  end

  enum Subtypes
    PCM_S8    = 0x0001,
    PCM_16    = 0x0002,
    PCM_24    = 0x0003,
    PCM_32    = 0x0004,
    PCM_U8    = 0x0005,
    FLOAT     = 0x0006,
    DOUBLE    = 0x0007,
    ULAW      = 0x0010,
    ALAW      = 0x0011,
    IMA_ADPCM = 0x0012,
    MS_ADPCM  = 0x0013,
    GSM610    = 0x0020,
    VOX_ADPCM = 0x0021,
    G721_32   = 0x0030,
    G723_24   = 0x0031,
    G723_40   = 0x0032,
    DWVW_12   = 0x0040,
    DWVW_16   = 0x0041,
    DWVW_24   = 0x0042,
    DWVW_N    = 0x0043,
    DPCM_8    = 0x0050,
    DPCM_16   = 0x0051,
    VORBIS    = 0x0060
  end

  enum Endians
    FILE   = 0x00000000,
    LITTLE = 0x10000000,
    BIG    = 0x20000000,
    CPU    = 0x30000000
  end

  enum Masks : CUInt
    SF_FORMAT_SUBMASK  = 0x0000FFFF,
    SF_FORMAT_TYPEMASK = 0x0FFF0000,
    SF_FORMAT_ENDMASK  = 0x30000000
  end

  enum DefaultSubtypes
    WAV   = Subtypes::PCM_16,
    AIFF  = Subtypes::PCM_16,
    AU    = Subtypes::PCM_16,
    PAF   = Subtypes::PCM_16,
    SVX   = Subtypes::PCM_16,
    NIST  = Subtypes::PCM_16,
    VOC   = Subtypes::PCM_16,
    IRCAM = Subtypes::PCM_16,
    W64   = Subtypes::PCM_16,
    MAT4  = Subtypes::DOUBLE,
    MAT5  = Subtypes::DOUBLE,
    PVF   = Subtypes::PCM_16,
    XI    = Subtypes::DPCM_16,
    HTK   = Subtypes::PCM_16,
    SDS   = Subtypes::PCM_16,
    AVR   = Subtypes::PCM_16,
    WAVEX = Subtypes::PCM_16,
    SD2   = Subtypes::PCM_16,
    FLAC  = Subtypes::PCM_16,
    CAF   = Subtypes::PCM_16,
    WVE   = Subtypes::ALAW,
    OGG   = Subtypes::VORBIS,
    MPC2K = Subtypes::PCM_16,
    RF64  = Subtypes::PCM_16
  end

  enum Whence
    SEEK_SET = 0
    SEEK_CUR = 1
    SEEK_END = 2
  end

  enum Command
    SFC_GET_LIB_VERSION            = 0x1000
    SFC_GET_LOG_INFO               = 0x1001
    SFC_GET_CURRENT_SF_INFO        = 0x1002
    SFC_GET_NORM_DOUBLE            = 0x1010
    SFC_GET_NORM_FLOAT             = 0x1011
    SFC_SET_NORM_DOUBLE            = 0x1012
    SFC_SET_NORM_FLOAT             = 0x1013
    SFC_SET_SCALE_FLOAT_INT_READ   = 0x1014
    SFC_SET_SCALE_INT_FLOAT_WRITE  = 0x1015
    SFC_GET_SIMPLE_FORMAT_COUNT    = 0x1020
    SFC_GET_SIMPLE_FORMAT          = 0x1021
    SFC_GET_FORMAT_INFO            = 0x1028
    SFC_GET_FORMAT_MAJOR_COUNT     = 0x1030
    SFC_GET_FORMAT_MAJOR           = 0x1031
    SFC_GET_FORMAT_SUBTYPE_COUNT   = 0x1032
    SFC_GET_FORMAT_SUBTYPE         = 0x1033
    SFC_CALC_SIGNAL_MAX            = 0x1040
    SFC_CALC_NORM_SIGNAL_MAX       = 0x1041
    SFC_CALC_MAX_ALL_CHANNELS      = 0x1042
    SFC_CALC_NORM_MAX_ALL_CHANNELS = 0x1043
    SFC_GET_SIGNAL_MAX             = 0x1044
    SFC_GET_MAX_ALL_CHANNELS       = 0x1045
    SFC_SET_ADD_PEAK_CHUNK         = 0x1050
    SFC_SET_ADD_HEADER_PAD_CHUNK   = 0x1051
    SFC_UPDATE_HEADER_NOW          = 0x1060
    SFC_SET_UPDATE_HEADER_AUTO     = 0x1061
    SFC_FILE_TRUNCATE              = 0x1080
    SFC_SET_RAW_START_OFFSET       = 0x1090
    SFC_SET_DITHER_ON_WRITE        = 0x10A0
    SFC_SET_DITHER_ON_READ         = 0x10A1
    SFC_GET_DITHER_INFO_COUNT      = 0x10A2
    SFC_GET_DITHER_INFO            = 0x10A3
    SFC_GET_EMBED_FILE_INFO        = 0x10B0
    SFC_SET_CLIPPING               = 0x10C0
    SFC_GET_CLIPPING               = 0x10C1
    SFC_GET_CUE_COUNT              = 0x10CD
    SFC_GET_INSTRUMENT             = 0x10D0
    SFC_SET_INSTRUMENT             = 0x10D1
    SFC_GET_LOOP_INFO              = 0x10E0
    SFC_GET_BROADCAST_INFO         = 0x10F0
    SFC_SET_BROADCAST_INFO         = 0x10F1
    SFC_GET_CHANNEL_MAP_INFO       = 0x1100
    SFC_SET_CHANNEL_MAP_INFO       = 0x1101
    SFC_RAW_DATA_NEEDS_ENDSWAP     = 0x1110
    SFC_WAVEX_SET_AMBISONIC        = 0x1200
    SFC_WAVEX_GET_AMBISONIC        = 0x1201
    SFC_RF64_AUTO_DOWNGRADE        = 0x1210
    SFC_SET_VBR_ENCODING_QUALITY   = 0x1300
    SFC_SET_COMPRESSION_LEVEL      = 0x1301
    SFC_SET_CART_INFO              = 0x1400
    SFC_GET_CART_INFO              = 0x1401
  end

  enum Ambisonic
    SF_AMBISONIC_NONE     = 0x40,
    SF_AMBISONIC_B_FORMAT = 0x41
  end

  enum Loop
    NONE        = 800
    FORWARD
    BACKWARD
    ALTERNATING
  end

  struct SFInfo
    frames : SFCount
    samplerate : CInt
    channels : CInt
    format : CInt
    sections : CInt
    seekable : CInt
  end

  struct SFFormatInfo
    format : CLong
    name : CChar*
    extension : CChar*
  end

  struct SFEmbedFileInfo
    offset : SFCount
    length : SFCount
  end

  struct SFBroadcastInfo
    description : CChar*          # 256
    originator : CChar*           # 32
    originator_reference : CChar* # 32
    origination_date : CChar*     # 10
    origination_time : CChar*     # 8
    time_reference_low : CInt     #
    time_reference_high : CInt    #
    version : CShort              #
    umid : CChar*                 # 64
    reserved : CChar*             # 190
    coding_history_size : CInt    #
    coding_history : CChar*       # 256
  end

  struct SFCartTimer #
    usage : CChar*   # [4]
    value : CInt     #
  end

  struct SFCartInfo
    version : CChar*              # version [4] :
    title : CChar*                # title [64] :
    artist : CChar*               # artist [64] :
    cut_id : CChar*               # cut_id [64] :
    client_id : CChar*            # client_id [64] :
    category : CChar*             # category [64] :
    classification : CChar*       # classification [64] :
    out_cue : CChar*              # out_cue [64] :
    start_date : CChar*           # start_date [10] :
    start_time : CChar*           # start_time [8] :
    end_date : CChar*             # end_date [10] :
    end_time : CChar*             # end_time [8] :
    producer_app_id : CChar*      # producer_app_id [64] :
    producer_app_version : CChar* # producer_app_version [64]
    user_def : CChar*             # user_def [64] :
    level_reference : CInt        # level_reference :
    post_timers : SFCartTimer     # post_timers [8] :
    reserved : CChar*             # reserved [276] :
    url : CChar*                  # url [1024] :
    tag_text_size : CInt          # tag_text_size :
    tag_text : CChar*             # tag_text[p_tag_text_size]
  end

  struct SFCuePoint
    indx : CInt
    position : CUInt
    fcc_chunk : CInt
    chunk_start : CInt
    block_start : CInt
    sample_offset : CUInt
    name : CChar* # char [256]
  end

  struct SFCues
    cue_count : CUInt
    cue_points : SFCuePoint # [count]
  end

  struct SFInstrument
    gain : CInt
    basenote, detune : CChar
    velocity_lo, velocity_hi : CChar
    key_lo, key_hi : CChar
    loop_count : CInt
  end

  struct SFLoop
    loop_mode : CInt
    loop_start : CUInt
    loop_end : CUInt
    loop_count : CUInt
  end

  struct SFLoopInfo
    time_sig_num : CShort # any positive integer    > 0  */
    time_sig_den : CShort # any positive power of 2 > 0  */
    loop_mode : CUInt     # see Loop enum             */
    num_beats : CUInt     # this is NOT the amount of quarter notes !!!*/
    bpm : CFloat          # suggestion, as it can be calculated using other fields:*/
    root_key : CUInt      # MIDI note, or -1 for None */
    future : CUInt        # [6]
  end

  fun open = "sf_open"(path : CChar*, mode : Mode, sfinfo : SFInfo*) : SndFile*
  fun open_fd = "sf_open_fd"(fd : CInt, mode : Mode, sfinfo : SFInfo*, close_desc : CloseDesc) : SndFile*
  fun close = "sf_close"(sndfile : SndFile*) : CInt
  fun error = "sf_error"(sndfile : SndFile*) : CInt
  fun str_error = "sf_error_number"(error_num : CInt) : CChar*
  fun format_check = "sf_format_check"(info : SFInfo*) : TBool
  fun get_string = "sf_get_string"(sndfile : SndFile*, str_type : CInt) : CChar*
  fun read_raw = "sf_read_raw"(sndfile : SndFile*, ptr : CChar*, bytes : SFCount) : SFCount
  fun read_short = "sf_read_short"(sndfile : SndFile*, ptr : CShort*, items : SFCount) : SFCount
  fun read_int = "sf_read_int"(sndfile : SndFile*, ptr : CInt*, items : SFCount) : SFCount
  fun read_float = "sf_read_float"(sndfile : SndFile*, ptr : CFloat*, items : SFCount) : SFCount
  fun read_double = "sf_read_double"(sndfile : SndFile*, ptr : CDouble*, items : SFCount) : SFCount
  fun readf_short = "sf_readf_short"(sndfile : SndFile*, ptr : CShort*, frames : SFCount) : SFCount
  fun readf_int = "sf_readf_int"(sndfile : SndFile*, ptr : CInt*, frames : SFCount) : SFCount
  fun readf_float = "sf_readf_float"(sndfile : SndFile*, ptr : CFloat*, frames : SFCount) : SFCount
  fun readf_double = "sf_readf_double"(sndfile : SndFile*, ptr : CDouble*, frames : SFCount) : SFCount
  fun write_raw = "sf_write_raw"(sndfile : SndFile*, ptr : CChar*, bytes : SFCount) : SFCount
  fun write_short = "sf_write_short"(sndfile : SndFile*, ptr : CShort*, items : SFCount) : SFCount
  fun write_int = "sf_write_int"(sndfile : SndFile*, ptr : CInt*, items : SFCount) : SFCount
  fun write_float = "sf_write_float"(sndfile : SndFile*, ptr : CFloat*, items : SFCount) : SFCount
  fun write_double = "sf_write_double"(sndfile : SndFile*, ptr : CDouble*, items : SFCount) : SFCount
  fun writef_short = "sf_writef_short"(sndfile : SndFile*, ptr : CShort*, items : SFCount) : SFCount
  fun writef_int = "sf_writef_int"(sndfile : SndFile*, ptr : CInt*, items : SFCount) : SFCount
  fun writef_float = "sf_writef_float"(sndfile : SndFile*, ptr : CFloat*, items : SFCount) : SFCount
  fun writef_double = "sf_writef_double"(sndfile : SndFile*, ptr : CDouble*, items : SFCount) : SFCount
  fun seek = "sf_seek"(sndfile : SndFile*, frames : SFCount, int : Whence) : SFCount
  fun set_string = "sf_set_string"(sndfile : SndFile*, str_type : CInt, str : CChar*)
  fun get_string = "sf_get_string"(sndfile : SndFile*, str_type : CInt) : CChar*
  fun command = "sf_command"(sndfile : SndFile*, cmd : CInt, data : Void*, datasize : CInt) : CInt
end

module SoundFile
  class SFile
    @info : LibSndFile::SFInfo
    @handle : Pointer(LibSndFile::SndFile) | Nil

    property info
    property handle

    def initialize(@info = LibSndFile::SFInfo.new)
    end

    def self.open(filename, mode, info = self.info)
      info.format = 0 if mode == :read
      fs = SFile.new(info)
      fs.open(filename, mode)
      begin
        yield fs
      ensure
        fs.close
      end
    end

    def self.info
      LibSndFile::SFInfo.new
    end

    def open(filename, mode)
      mode = LibSndFile::Mode.parse(mode.to_s)
      @info.format = 0 if mode == :read
      @handle = LibSndFile.open(filename, mode, pointerof(@info))
      no_error?
    end

    def open(filename, mode)
      mode = LibSndFile::Mode.parse(mode.to_s)
      @info.format = 0 if mode == :read
      @handle = LibSndFile.open(filename, mode, pointerof(@info))
      begin
        yield self
      ensure
        self.close
      end
    end

    def open_fd(descriptor : Int32, mode, close_desc = false)
      mode = LibSndFile::Mode.parse(mode.to_s)
      close_d = close_desc ? 1 : 0
      @handle = LibSndFile.open_fd(descriptor, mode, pointerof(@info), close_d)
      no_error?
    end

    def open_fd(descriptor : Int32, mode, close_desc = false)
      mode = LibSndFile::Mode.parse(mode.to_s)
      close_d = close_desc ? 1 : 0
      @handle = LibSndFile.open_fd(descriptor, mode, pointerof(@info), close_d)
      begin
        yield self
      ensure
        self.close
      end
    end

    def open_file(file : File, mode, close_desc = false)
      mode = LibSndFile::Mode.parse(mode.to_s)
      close_d = close_desc ? 1 : 0
      @handle = LibSndFile.open_fd(file.fd, mode, pointerof(@info), close_d)
      no_error?
    end

    def open_file(file : File, mode, close_desc = false)
      mode = LibSndFile::Mode.parse(mode.to_s)
      close = close_desc ? 1 : 0
      @handle = LibSndFile.open_fd(file.fd, mode, pointerof(@info), close)
      begin
        yield self
      ensure
        self.close
      end
    end

    def sf_true
      LibSndFile::TBool::SF_TRUE
    end

    def sf_false
      LibSndFile::TBool::SF_FALSE
    end

    def extract_format_info(ptr)
      format_info = ptr.value
      name = String.new(format_info.name)
      extension = String.new(format_info.extension)
      format = format_info.format
      {name, extension, format}
    end

    def default_simple_format
      get_simple_format(fmt = 0)
    end

    def [](type)
      get_string(type)
    end

    def []=(type, str)
      set_string(str, type)
    end

    def set_string(str, type)
      type = LibSndFile::StringType.parse(type).value
      LibSndFile.set_string(@handle, type, str)
    end

    def get_string(type)
      type = LibSndFile::StringType.parse(type).value
      str = LibSndFile.get_string(@handle, type)
      return "" unless str
      String.new(str)
    end

    def read_raw(ptr, size)
      LibSndFile.read_raw(@handle, ptr, size)
    end

    def read_short(ptr, size)
      LibSndFile.read_short(@handle, ptr, size)
    end

    def read_int(ptr, size)
      LibSndFile.read_int(@handle, ptr, size)
    end

    def read_float(ptr, size)
      LibSndFile.read_float(@handle, ptr, size)
    end

    def read_double(ptr, size)
      LibSndFile.read_double(@handle, ptr, size)
    end

    def readf_short(ptr, size)
      LibSndFile.read_short(@handle, ptr, size)
    end

    def readf_int(ptr, size)
      LibSndFile.read_int(@handle, ptr, size)
    end

    def readf_float(ptr, size)
      LibSndFile.read_float(@handle, ptr, size)
    end

    def readf_double(ptr, size)
      LibSndFile.read_double(@handle, ptr, size)
    end

    def write_short(ptr, size)
      LibSndFile.write_short(@handle, ptr, size)
    end

    def write_raw(ptr, size)
      LibSndFile.write_raw(@handle, ptr, size)
    end

    def write_int(ptr, size)
      LibSndFile.write_int(@handle, ptr, size)
    end

    def write_float(ptr, size)
      LibSndFile.write_float(@handle, ptr, size)
    end

    def write_double(ptr, size)
      LibSndFile.write_double(@handle, ptr, size)
    end

    def writef_short(ptr, size)
      LibSndFile.writef_short(@handle, ptr, size)
    end

    def writef_int(ptr, size)
      LibSndFile.writef_int(@handle, ptr, size)
    end

    def writef_float(ptr, size)
      LibSndFile.writef_float(@handle, ptr, size)
    end

    def writef_double(ptr, size)
      LibSndFile.writef_double(@handle, ptr, size)
    end

    def seek(frames, whence)
      whence = LibSndFile::Whence.parse(whence)
      LibSndFile.seek(@handle, frames, whence)
    end

    def close
      LibSndFile.close(@handle)
    end

    def error_number
      LibSndFile.error(@handle)
    end

    def error_to_s
      String.new(LibSndFile.str_error(error_number))
    end

    def no_error?
      0 == error_number
    end

    def format_check
      sf_true == LibSndFile.format_check(pointerof(@info))
    end

    def format_raw
      @info.format
    end

    def sub_type
      mask_subtype = LibSndFile::Masks::SF_FORMAT_SUBMASK.value
      LibSndFile::Subtypes.from_value(@info.format & mask_subtype).to_s
    end

    def format_type
      mask_format = LibSndFile::Masks::SF_FORMAT_TYPEMASK.value
      LibSndFile::Formats.from_value(@info.format & mask_format).to_s
    end

    def endian_type
      mask_end = LibSndFile::Masks::SF_FORMAT_ENDMASK.value
      LibSndFile::Endians.from_value(@info.format & mask_end).to_s
    end

    def format_to_hash
      {
        "subtype" => sub_type,
        "format"  => format_type,
        "endian"  => endian_type,
      }
    end

    def format_to_tuple
      {
        sub_type,
        format_type,
        endian_type,
      }
    end

    def format_to_s
      "Format: " + format_type + ", Subtype: " + sub_type + ", Endian: " + endian_type
    end

    def sample_rate
      @info.samplerate
    end

    def frames
      @info.frames
    end

    def channels
      @info.channels
    end

    def sections
      @info.channels
    end

    def seekable?
      @info.seekable == 1
    end

    def size
      Int32.new(@info.frames * @info.channels)
    end

    def version
      VERSION
    end

    def sf_version
      ver = Bytes.new(25)
      cmd = LibSndFile::Command::SFC_GET_LIB_VERSION
      LibSndFile.command(@handle, cmd, ver, ver.size)
      String.new(ver).strip
    end

    def get_log_info
      log = Slice.new(2048, Char)
      #    log = Bytes.new(2048)
      cmd = LibSndFile::Command::SFC_GET_LOG_INFO
      LibSndFile.command(@handle, cmd, log, log.size)
      #    return nil unless LibSndFile.command(@handle, cmd, log, log.size) > 0
      #    String.new(log)
    end

    def calc_signal_max
      max = Float64.new(0.0)
      max_ptr = pointerof(max)
      cmd = LibSndFile::Command::SFC_CALC_SIGNAL_MAX
      return nil unless LibSndFile.command(@handle, cmd, max_ptr, sizeof(Float64)) == 0
      max
    end

    def calc_norm_signal_max
      max = Float64.new(0.0)
      max_ptr = pointerof(max)
      cmd = LibSndFile::Command::SFC_CALC_NORM_SIGNAL_MAX
      return nil unless LibSndFile.command(@handle, cmd, max_ptr, sizeof(Float64)) == 0
      max
    end

    def calc_max_all_channels
      max = Slice.new(channels, Float64.new(0.0))
      cmd = LibSndFile::Command::SFC_CALC_MAX_ALL_CHANNELS
      return nil unless LibSndFile.command(@handle, cmd, max, sizeof(Float64) * channels) == 0
      max.to_a
    end

    def calc_norm_max_all_channels
      max = Slice.new(channels, Float64.new(0.0))
      cmd = LibSndFile::Command::SFC_CALC_NORM_MAX_ALL_CHANNELS
      return nil unless LibSndFile.command(@handle, cmd, max, sizeof(Float64) * channels) == 0
      max.to_a
    end

    def get_signal_max
      max = Float64.new(0.0)
      max_ptr = pointerof(max)
      cmd = LibSndFile::Command::SFC_GET_SIGNAL_MAX
      return nil unless LibSndFile.command(@handle, cmd, max_ptr, sizeof(Float64)) == 1
      max
    end

    def get_max_all_channels
      max = Slice.new(channels, Float64.new(0.0))
      cmd = LibSndFile::Command::SFC_GET_MAX_ALL_CHANNELS
      return nil unless LibSndFile.command(@handle, cmd, max, sizeof(Float64) * channels) == 1
      max.to_a
    end

    def set_norm_float(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_NORM_FLOAT
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def set_norm_double(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_NORM_DOUBLE
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def get_norm_float
      cmd = LibSndFile::Command::SFC_GET_NORM_FLOAT
      LibSndFile.command(@handle, cmd, nil, 0)
    end

    def get_norm_double
      cmd = LibSndFile::Command::SFC_GET_NORM_DOUBLE
      LibSndFile.command(@handle, cmd, nil, 0)
    end

    def set_scale_float_int_read(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_SCALE_FLOAT_INT_READ
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def set_scale_int_float_write(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_SCALE_INT_FLOAT_WRITE
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def get_simple_format_count
      count = Int32.new(0)
      count_ptr = pointerof(count)
      cmd = LibSndFile::Command::SFC_GET_SIMPLE_FORMAT_COUNT
      return nil unless LibSndFile.command(@handle, cmd, count_ptr, sizeof(Int32)) == 0
      count
    end

    def get_simple_format(fmt = 9)
      format_info = LibSndFile::SFFormatInfo.new
      format_info.format = fmt
      ptr = pointerof(format_info)
      cmd = LibSndFile::Command::SFC_GET_SIMPLE_FORMAT
      size = sizeof(LibSndFile::SFFormatInfo)
      return nil unless LibSndFile.command(@handle, cmd, ptr, size) == 0
      format_info
    end

    def get_format_info
      #    #todo
      #    ptr = get_simple_format()
      #    pp "ptr = #{ptr.not_nil!.value}"
      #    puts "format_info = #{format_info}"
      #    ptr = pointerof(format_info)
      #    return nil unless
      #    pp LibSndFile.command(@handle, cmd, ptr.not_nil!, size)
      #    pp ptr.value
      raise "get_format_info not yet implemented!"
    end

    def get_format_major_count
      count = Int32.new(0)
      count_ptr = pointerof(count)
      cmd = LibSndFile::Command::SFC_GET_FORMAT_MAJOR_COUNT
      raise "format_major_count error" unless LibSndFile.command(@handle, cmd, count_ptr, sizeof(Int32)) == 0
      count
    end

    def get_format_subtype_count
      count = Int32.new(0)
      count_ptr = pointerof(count)
      cmd = LibSndFile::Command::SFC_GET_FORMAT_SUBTYPE_COUNT
      raise "format_subtype_count error" unless LibSndFile.command(@handle, cmd, count_ptr, sizeof(Int32)) == 0
      count
    end

    def set_add_peak_chunk(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_ADD_PEAK_CHUNK
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def update_header_now
      cmd = LibSndFile::Command::SFC_UPDATE_HEADER_NOW
      LibSndFile.command(@handle, cmd, nil, 0)
    end

    def set_update_header_auto(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_UPDATE_HEADER_AUTO
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def file_truncate(frames : Int32)
      frames = LibSndFile::SFCount.new(frames)
      ptr = pointerof(frames)
      cmd = LibSndFile::Command::SFC_FILE_TRUNCATE
      LibSndFile.command(@handle, cmd, ptr, sizeof(LibSndFile::SFCount))
    end

    def set_raw_start_offset(frames : Int32)
      frames = LibSndFile::SFCount.new(frames)
      ptr = pointerof(frames)
      cmd = LibSndFile::Command::SFC_SET_RAW_START_OFFSET
      LibSndFile.command(@handle, cmd, ptr, sizeof(LibSndFile::SFCount))
    end

    def set_clipping(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_SET_CLIPPING
      LibSndFile.command(@handle, cmd, nil, true_false)
    end

    def get_clipping
      cmd = LibSndFile::Command::SFC_GET_CLIPPING
      LibSndFile.command(@handle, cmd, nil, 0)
    end

    def get_embed_file_info
      data = LibSndFile::SFEmbedFileInfo.new
      ptr = pointerof(data)
      cmd = LibSndFile::Command::SFC_GET_EMBED_FILE_INFO
      LibSndFile.command(@handle, cmd, ptr, sizeof(LibSndFile::SFEmbedFileInfo))
    end

    def wavex_get_ambisonic
      cmd = LibSndFile::Command::SFC_WAVEX_GET_AMBISONIC
      res = LibSndFile.command(@handle, cmd, nil, 0)
      return "SF_AMBISONIC_NONE" if res == LibSndFile::Ambisonic::SF_AMBISONIC_NONE.value
      return "SF_AMBISONIC_B_FORMAT" if res == LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT.value
      res.to_s(16)
    end

    def wavex_set_ambisonic(ambi)
      val = LibSndFile::Ambisonic::SF_AMBISONIC_NONE
      val = LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT if ambi == :b_format
      cmd = LibSndFile::Command::SFC_WAVEX_SET_AMBISONIC
      res = LibSndFile.command(@handle, cmd, nil, val.value)
      return "SF_AMBISONIC_NONE" if res == LibSndFile::Ambisonic::SF_AMBISONIC_NONE.value
      return "SF_AMBISONIC_B_FORMAT" if res == LibSndFile::Ambisonic::SF_AMBISONIC_B_FORMAT.value
      res
    end

    def set_vbr_encoding_quality(quality : Float64)
      if (quality < 0.0) || (quality > 1.0)
        raise "Error: Invalid vbr encoding quality"
      end
      quality_ptr = pointerof(quality)
      cmd = LibSndFile::Command::SFC_SET_VBR_ENCODING_QUALITY
      LibSndFile.command(@handle, cmd, quality_ptr, sizeof(Float64))
    end

    def set_compression_level(level : Float64)
      if (level < 0.0) || (level > 1.0)
        raise "Error: Invalid compression level"
      end
      level_ptr = pointerof(level)
      cmd = LibSndFile::Command::SFC_SET_COMPRESSION_LEVEL
      LibSndFile.command(@handle, cmd, level_ptr, sizeof(Float64))
    end

    def raw_data_needs_endswap
      cmd = LibSndFile::Command::SFC_RAW_DATA_NEEDS_ENDSWAP
      LibSndFile.command(@handle, cmd, nil, 0)
    end

    def get_broadcast_info
      # SFC_GET_BROADCAST_INFO         = 0x10F0
      raise " not yet implemented!"
    end

    def set_broadcast_info
      # todo
      #    SFC_SET_BROADCAST_INFO         = 0x10F0
      raise "get_broadcast_info not yet implemented!"
    end

    def set_cart_info
      # todo
      # SFC_SET_CART_INFO	Set the Cart Chunk info
      raise "set_cart_info not yet implemented!"
    end

    def get_cart_info
      # todo
      # SFC_GET_CART_INFO	Retrieve the Cart Chunk info
      raise "get_cart_info not yet implemented!"
    end

    def get_loop_info
      # GET_LOOP_INFO	Get loop info
      raise " not yet implemented!"
    end

    def get_instrument
      # todo
      # SFC_GET_INSTRUMENT	Get instrument info
      raise "get_loop_info not yet implemented!"
    end

    def set_instrument
      # todo
      # SFC_SET_INSTRUMENT	Set instrument info
      raise "set_instrument not yet implemented!"
    end

    def get_cue_count
      count = UInt32.new(0)
      cmd = LibSndFile::Command::SFC_GET_CUE_COUNT
      res = LibSndFile.command(@handle, cmd, pointerof(count), sizeof(UInt32))
      raise "Error getting cue count" unless res == 0
      count
    end

    def get_cue
      # SFC_GET_CUE	Get cue marker info
      raise "get_cue not yet implemented!"
    end

    def set_cue
      # todo
      # SFC_SET_CUE	Set cue marker info
      raise "set_cue not yet implemented!"
    end

    def rf64_auto_downgrade(val)
      true_false = val == :true ? sf_true : sf_false
      cmd = LibSndFile::Command::SFC_RF64_AUTO_DOWNGRADE
      LibSndFile.command(@handle, cmd, nil, true_false)
    end
  end

  # end of SFile

end

# end of SoundFile
