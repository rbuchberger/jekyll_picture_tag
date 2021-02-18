# Tests for a generic Instruction
class TestInstructions < Minitest::Test
  include TestHelper

  def tested
    @tested ||= build_tested
  end

  def build_tested
    subject = PictureTag::Instructions::Instruction.new
    subject.stubs(source: 'setting')

    subject
  end

  def test_value
    assert_equal 'setting', tested.value
  end

  def test_validation_fail
    tested.stubs(valid?: false)

    assert_raises(ArgumentError) { tested.value }
  end

  def test_coercion
    tested.stubs(coerce: 'coerced')
    assert_equal 'coerced', tested.value
  end
end
