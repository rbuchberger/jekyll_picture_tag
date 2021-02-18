class RouterTest < Minitest::Test
  include TestHelper

  def tested(*args)
    stub.instruction_stub(*args)
  end

  def stub
    @stub ||= build_stub
  end

  def instruction_stub
    PictureTag::Instructions::InstructionStub
  end

  def build_stub
    stub = Object.new
    stub.extend(PictureTag::Router)
    stub
  end

  def test_instantiate
    instruction_stub.any_instance.expects(:value)

    tested
  end

  # InstructionStub returns an array of whatever arguments are passed in.
  def test_round_trip
    assert_equal 'foo', *tested('foo')
  end

  def test_respond_existing
    assert_respond_to stub, :instruction_stub
  end

  def test_respond_missing
    refute_respond_to stub, :does_not_exist
  end

  def test_memoize
    tested

    instruction_stub.expects(:new).never
    tested
  end

  def test_clear_instructions
    tested

    stub.clear_instructions

    instruction_stub.any_instance.expects(:value)
    tested
  end
end
