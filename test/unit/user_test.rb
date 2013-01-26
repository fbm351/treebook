require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
    user = User.new
    user.profile_name = "My Profile With Spaces"
    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("must be formatted correctly.")
  end
end
