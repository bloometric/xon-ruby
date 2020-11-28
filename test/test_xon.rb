require 'minitest/autorun'
require 'xon'
require 'time'

class XonTest < Minitest::Test

  def test_without_time
    obj = { "hello" => 1, "world" => ["2", "3"] }
    res = Xon.dump(obj)
    assert_equal '{"hello":1,"world":["2","3"]}', res
    assert_equal obj, Xon.load(res)
  end

  def test_with_time
    time = Time.parse("2020-12-01T13:37:00+02:00")
    obj = { "hello" =>  1, "world" => ["2", time] }
    res = Xon.dump(obj)
    assert_equal '!:{"hello":1,"world":[":2","t:2020-12-01T13:37:00+02:00"]}', res
    assert_equal obj, Xon.load(res)
  end

  def test_parser_error_wrong_type
    assert_raises(Xon::ParserError) do
      Xon.load('!:"x:hello"')
    end
  end

  def test_parser_error_no_string_prefix
    assert_raises(Xon::ParserError) do
      Xon.load('!:"hello"')
    end
  end

  def test_parser_error_invalid_time
    assert_raises(Xon::ParserError) do
      Xon.load('!:"t:hello"')
    end
  end

  def test_parser_error_invalid_json_without_preamble
    assert_raises(Xon::ParserError) do
      Xon.load('{')
    end
  end

  def test_parser_error_invalid_json_with_preamble
    assert_raises(Xon::ParserError) do
      Xon.load('!:{')
    end
  end

end
