# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# Geekcoffee::Application.config.secret_token = '0fe54cd9a3be5f34d6ceb9441e9bf51f0fdd0ff7c80521b815599bce5e07bc1a34b0fa6d3f41d65129a1d2cae5862e229eb42896a820beb4606b2eaca148dd25'
Geekcoffee::Application.config.secret_token = ENV['SECRET_TOKEN']
