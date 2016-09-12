require_relative '../test_helper'
require_relative '../../lib/extrator'

class Extractor::BaseTest <  Minitest::Test
  include Rack::Test::Methods

  def setup
    @user = Minitest::Mock.new
  end

  def test_extract_call_extrator
    Extractor::Statement.stub :extract, :foo do
      @user.expect :transactions, :foo

      domains = Extractor::Base.extract(@user)

      @user.verify
      assert_equal domains, :foo
    end
  end
end
