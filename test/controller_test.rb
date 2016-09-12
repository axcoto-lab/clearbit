require_relative './test_helper'
require_relative '../controller'

class ControllerTest <  Minitest::Test
  include Rack::Test::Methods
  TEXT_BUTTON = <<-BUTTON
<script
  src="https://cdn.plaid.com/link/stable/link-initialize.js"
  data-client-name="Dummy"
  data-form-id="plaid-auth"
  data-key="test_key"
  data-product="auth"
  data-env="tartan">
</script>
  BUTTON

  TRANSACTION_ONE = { '_account' => 'XARE85EJqKsjxLp6XR8ocg8VakrkXpTXmRdOo',
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
  TRANSACTION_TWO = { '_account' => 'XARE85EJqKsjxLp6XR8ocg8VakrkXpTXmRdOo',
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
  RECURRING_TRANSACTION = { '_account' => 'XARE85EJqKsjxLp6XR8ocg8VakrkXpTXmRdOo',
                          '_id' => 'foo',
                          'amount' => 100,
                          'date' => '2016-07-21',
                          'name' => 'Phone payment comcast.com Recurring',
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
    @transactions = [Plaid::Transaction.new(TRANSACTION_ONE), Plaid::Transaction.new(TRANSACTION_TWO)]
    @recurring_transactions = [Plaid::Transaction.new(RECURRING_TRANSACTION)]
  end

  def app
    Sinatra::Application
  end

  def test_it_shows_link_button
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('src="https://cdn.plaid.com/link/stable/link-initialize.js"')
  end

  def test_it_extracts_domain_to_authenticated_user
    Plaid::User.stub :exchange_token, @user do
      @user.expect :transactions, @transactions
      @user.expect :transactions, @transactions

      post '/authenticate', :public_token => 'token'

      @user.verify
      assert last_response.body.include?(TRANSACTION_ONE['_id'])
      assert last_response.body.include?(TRANSACTION_TWO['_id'])
      assert last_response.body.include?('Starbucks')
      assert last_response.body.include?('["+1 800-782-7282", "+1 206-318-7118", "+1 800-952-5210", "+1 206-318-3432"]')
    end
  end

  def test_it_show_recurring_statement
    Plaid::User.stub :exchange_token, @user do
      @user.expect :transactions, @recurring_transactions
      @user.expect :transactions, @recurring_transactions

      post '/authenticate', :public_token => 'token'

      @user.verify
      assert last_response.body.include?('<td>Recurring</td>')
    end
  end
end
