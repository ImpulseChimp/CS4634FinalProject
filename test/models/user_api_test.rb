require 'test_helper'
require File.dirname(__FILE__).sub('test/models','') + 'app/models/apis/user_api'

class UserApiTest < ActiveSupport::TestCase

  test 'succeed at creating a password' do

    testUserAPI = UserAPI.new(nil, nil, nil)
    assert_not_nil(testUserAPI.create_password('', 'testtest1', 'testtest1'))
  end

  test 'fail at creating a password' do

    testUserAPI = UserAPI.new(nil, nil, nil)
    assert_nil(testUserAPI.create_password('', 'testpassword', 'testpasswor'))
    assert_nil(testUserAPI.create_password('', 'testpassword', 'testpassword'))
  end

  test 'succeed at creating email' do

    testUserAPI = UserAPI.new(nil, nil, nil)
    assert_not_nil(testUserAPI.create_email('', 'a@a.aa'))
    assert_not_nil(testUserAPI.create_email('', 'a@a.aaa'))
    assert_not_nil(testUserAPI.create_email('', 'a@a.aaaa'))
    assert_not_nil(testUserAPI.create_email('', 'test@test.com'))
    assert_not_nil(testUserAPI.create_email('', 'test@test.edu'))
    assert_not_nil(testUserAPI.create_email('', 'test@test.edu'))
    assert_not_nil(testUserAPI.create_email('', 'test@email.test.test.com'))
  end

  test 'fail at creating_email' do

    testUserAPI = UserAPI.new(nil, nil, nil)
    assert_nil(testUserAPI.create_email('', 'a@a.a'))
    assert_nil(testUserAPI.create_email('', 'a@a.aaaaa'))
    assert_nil(testUserAPI.create_email('', '@a.aaaa'))
    assert_nil(testUserAPI.create_email('', 'testtest.com'))
    assert_nil(testUserAPI.create_email('', 'test@edu'))
    assert_nil(testUserAPI.create_email('', 'test@.edu'))
    assert_nil(testUserAPI.create_email('', 'test@email'))
  end

end