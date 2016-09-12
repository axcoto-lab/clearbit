require_relative '../../test_helper'
require_relative '../../../lib/extrator/statement'

class Extractor::StatementTest <  Minitest::Test
  include Rack::Test::Methods

  STATEMENT_ONE = { '_account' => 'XARE85EJqKsjxLp6XR8ocg8VakrkXpTXmRdOo',
                    '_id' => '0AZ0De04KqsreDgVwM1RSRYjyd8yXxSDQ8Zxn',
                    'amount' => 200,
                    'date' => '2014-07-21',
                    'name' => 'ATM Withdrawal',
                    'meta' => {
                      'location' => {
                        'city' => 'San Francisco',
                        'state' => 'CA' } },
                        'pending' => '',
                        '_pendingTransaction' => 'Nw83eMkqVXSaZvM17aVqtoOwLo1nOAipXeZ74',
                        'type' => { 'primary' => 'special' },
                        'category' => %w(Transfer Withdrawal ATM),
                        'category_id' => '21012002',
                        'score' => {
                          'location' => { 'city' => 1, 'state' => 1 }, 'name' => 1 } }
  STATEMENT_TWO = { '_account' => 'XARE85EJqKsjxLp6XR8ocg8VakrkXpTXmRdOo',
                    '_id' => 'foo',
                    'amount' => 100,
                    'date' => '2016-07-21',
                    'name' => 'Coffee at starbucks.com',
                    'meta' => {
                      'location' => {
                        'city' => 'San Francisco',
                        'state' => 'CA' } },
                        'pending' => 'Pending',
                        '_pendingTransaction' => 'Nw83eMkqVXSaZvM17aVqtoOwLo1nOAipXeZ74',
                        'type' => { 'primary' => 'special' },
                        'category' => %w(Transfer Withdrawal ATM),
                        'category_id' => '21012002',
                        'score' => {
                          'location' => { 'city' => 1, 'state' => 1 }, 'name' => 1 } }

  def setup
    @user = Minitest::Mock.new
    @transactions = [Plaid::Transaction.new(STATEMENT_ONE), Plaid::Transaction.new(STATEMENT_TWO)]
  end

  def test_extract_call_extrator
      @user.expect :transactions, @transactions

      domains = Extractor::Base.extract(@user)

      @user.verify
      assert_equal "Starbucks", domains.last.name
  end
end
