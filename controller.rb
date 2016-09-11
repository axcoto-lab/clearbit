get '/' do
	# flash[:info] = 'This is a flash message'
  puts settings
  erb :index, locals: { :plaid_public_key => settings.plaid_public_key}
end

require 'pp'

post '/authenticate' do
  info_user = Plaid::User.create(:info, 'chase', 'plaid_test', 'plaid_good', pin: '1234', options: {:list => true})
  domain_info = Extractor::Mfa.extract(info_user)


  user = Plaid::User.exchange_token(params['public_token'])
  statement = user.transactions

  statement_domain = Extractor::Statement.extract(stament)

  puts statement_domain

  erb :authenticate, locals: {
    domain_info: domain_info,
    statement_domain: statement_domain,
    statement: statement}
end
