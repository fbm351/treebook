require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:user_friendships)
  should have_many(:friends)

  test "a user should enter a first name" do
      user = User.new
      assert !user.save
      assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
      user = User.new
      assert !user.save
      assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
      user = User.new
      assert !user.save
      assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
    user = User.new
    user.email = "fred@fred-myers.com"
    user.profile_name = "fredmyers"
    user.first_name = "Fred"
    user.last_name = "Myers"
    user.password = "P@ssw0rd"
    user.password_confirmation = "P@ssw0rd"
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'Fred', last_name: 'Myers', email: 'fred2@fred-myers.com')
    user.password = user.password_confirmation = 'asdfasdf'
    user.profile_name = "My Profile With Spaces"
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'Jason', last_name: 'Myers', email: 'fred2@fred-myers.com')
    user.password = user.password_confirmation = 'asdfasdf'
    user.profile_name = 'fred-myers_1'
    assert user.valid?
  end

  test "that no error is raised when trying to get to a users friend list" do
    assert_nothing_raised do
      users(:fred).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:fred).friends << users(:mike)
    users(:fred).friends.reload
    assert users(:fred).friends.include?(users(:mike))
  end

  test "that calling to_param on a user shows the profile name" do
    assert_equal "fredmyers", users(:fred).to_param
  end
end
