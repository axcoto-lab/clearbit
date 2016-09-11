require 'rubygems'
require 'bundler'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'bundler'
require 'sinatra/json'
require 'sinatra/cookies'
require 'sinatra/flash'
require './helpers'
require 'plaid'
Bundler.require(:default)

require 'dotenv'
Dotenv.load

Plaid.config do |p|
  p.client_id = ENV['PLAID_CLIENT_ID']
  p.secret = ENV['PLAID_SECRET']
  p.env = :tartan  # or :production
end

configure do
	enable :sessions
	set :json_encoder, :to_json
	set :erb, :layout => :layout
  set :server, :puma

  set :plaid_client_id, ENV["PLAID_CLIENT_ID"]
  set :plaid_secret, ENV["PLAID_SECRET"]
  set :plaid_public_key, ENV["PLAID_PUBLIC_KEY"]
end

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
end

require './controller'
