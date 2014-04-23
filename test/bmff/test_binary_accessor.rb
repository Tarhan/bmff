# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../minitest_helper'
require 'bmff/binary_accessor'
require 'stringio'

class TestBMFFBinaryAccessor < MiniTest::Unit::TestCase
  def test_get_int8
    io = StringIO.new("\x00\xFF\x80", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int8)
    assert_equal(-1, io.get_int8)
    assert_equal(-128, io.get_int8)
    assert(io.eof?)
  end

  def test_get_int8_insufficient_data
    io = StringIO.new("", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int8
    end
  end

  def test_get_uint8
    io = StringIO.new("\x00\xFF\xF0", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint8)
    assert_equal(255, io.get_uint8)
    assert_equal(240, io.get_uint8)
    assert(io.eof?)
  end

  def test_get_uint8_insufficient_data
    io = StringIO.new("", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint8
    end
  end

  def test_get_int16
    io = StringIO.new("\x00\xFF\xFF\xFF\x80\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(255, io.get_int16)
    assert_equal(-1, io.get_int16)
    assert_equal(-32768, io.get_int16)
    assert(io.eof?)
  end

  def test_get_int16_insufficient_data
    io = StringIO.new("\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int16
    end
  end

  def test_get_uint16
    io = StringIO.new("\x00\xFF\xFF\xFF", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(255, io.get_uint16)
    assert_equal(65535, io.get_uint16)
    assert(io.eof?)
  end

  def test_get_uint16_insufficient_data
    io = StringIO.new("\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint16
    end
  end

  def test_get_int32
    io = StringIO.new("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int32)
    assert_equal(-1, io.get_int32)
    assert_equal(-2147483648, io.get_int32)
    assert(io.eof?)
  end

  def test_get_int32_insufficient_data
    io = StringIO.new("\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int32
    end
  end

  def test_get_uint32
    io = StringIO.new("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint32)
    assert_equal(4294967295, io.get_uint32)
    assert_equal(2147483648, io.get_uint32)
    assert(io.eof?)
  end

  def test_get_uint32_insufficient_data
    io = StringIO.new("\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint32
    end
  end

  def test_get_int64
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                      "\x80\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int64)
    assert_equal(-1, io.get_int64)
    assert_equal(-9223372036854775808, io.get_int64)
    assert(io.eof?)
  end

  def test_get_int64_insufficient_data
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int64
    end
  end

  def test_get_uint64
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                      "\x80\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint64)
    assert_equal(18446744073709551615, io.get_uint64)
    assert_equal(9223372036854775808, io.get_uint64)
    assert(io.eof?)
  end

  def test_get_uint64_insufficient_data
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint64
    end
  end

  def test_get_ascii
    io = StringIO.new("abcdefgh", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("abcd", io.get_ascii(4))
    assert_equal("efgh", io.get_ascii(4))
    assert(io.eof?)
  end

  def test_get_ascii_null_terminated
    io = StringIO.new("ab\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("ab\x00\x00", io.get_ascii(4))
    assert(io.eof?)
  end

  def test_get_ascii_insufficient_data
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_ascii(4)
    end
  end

  def test_get_ascii_out_of_range
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.get_ascii(0)
    end
    assert_raises(RangeError) do
      io.get_ascii(-1)
    end
  end

  def test_get_ascii_invalid_size
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.get_ascii(1.0)
    end
    assert_raises(TypeError) do
      io.get_ascii(nil)
    end
    assert_raises(TypeError) do
      io.get_ascii("1")
    end
    assert_raises(TypeError) do
      io.get_ascii(true)
    end
    assert_raises(TypeError) do
      io.get_ascii(false)
    end
  end

  def test_get_byte
    io = StringIO.new("\x00\x01\x02\x03\x04\x05\x06\x07\xFF\xFE\xFD\xFC\xFB\xFA\xF9\xF8", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("\x00".force_encoding("ascii-8bit"), io.get_byte)
    assert_equal("\x01\x02".force_encoding("ascii-8bit"), io.get_byte(2))
    assert_equal("\x03\x04\x05".force_encoding("ascii-8bit"), io.get_byte(3))
    assert_equal("\x06\x07\xFF\xFE".force_encoding("ascii-8bit"), io.get_byte(4))
    assert_equal("\xFD\xFC\xFB\xFA\xF9".force_encoding("ascii-8bit"), io.get_byte(5))
    assert_equal("\xF8".force_encoding("ascii-8bit"), io.get_byte)
    assert(io.eof?)
  end

  def test_get_byte_insufficient_data
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_byte(3)
    end
  end

  def test_get_byte_out_of_range
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.get_byte(0)
    end
    assert_raises(RangeError) do
      io.get_byte(-1)
    end
  end

  def test_get_byte_invalid_size
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.get_byte(1.0)
    end
    assert_raises(TypeError) do
      io.get_byte(nil)
    end
    assert_raises(TypeError) do
      io.get_byte("1")
    end
    assert_raises(TypeError) do
      io.get_byte(true)
    end
    assert_raises(TypeError) do
      io.get_byte(false)
    end
  end

  def test_get_uuid
    io = StringIO.new("\x00\x01\x02\x03\x04\x05\x06\x07\x80\x90\xA0\xB0\xC0\xD0\xE0\xF0", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("\x00\x01\x02\x03\x04\x05\x06\x07\x80\x90\xA0\xB0\xC0\xD0\xE0\xF0".force_encoding("ascii-8bit"), io.get_uuid)
    assert(io.eof?)
  end

end
