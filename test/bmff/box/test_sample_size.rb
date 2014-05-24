# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSampleSize < MiniTest::Unit::TestCase
  def test_parse_size_0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsz")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # sample_size
    io.write_uint32(3) # sample_count
    3.times do |i|
      io.write_uint32(i) # entry_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SampleSize, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsz", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.sample_size)
    assert_equal(3, box.sample_count)
    assert_equal([0, 1, 2], box.entry_size)
  end

  def test_parse_size_1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsz")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # sample_size
    io.write_uint32(3) # sample_count
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SampleSize, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsz", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.sample_size)
    assert_equal(3, box.sample_count)
    assert_equal([], box.entry_size)
  end
end