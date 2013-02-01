require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
    context "#new" do
        
        context "When not logged in" do
            should "Redirect to login page" do
                get :new
                assert_response :redirect
            end
        end

        context "When logged in" do
            setup do
                sign_in users(:fred)
            end

            should "get new and return success" do
                get :new
                assert_response :success
            end

            should "set a flash error if the friend_id params are missing" do
                get :new, {}
                assert_equal "Friend required", flash[:error]
            end

            should "dispay the friend's name" do
                get :new, friend_id: users(:bob)
                assert_match /#{users(:bob).full_name}/, response.body
            end

            should "assign a new user friendship to the correct friend" do
                get :new, friend_id: users(:bob)
                assert_equal users(:bob), assigns(:user_friendship).friend
            end

            should "assign a new user friendship to the currently logged in user" do
                get :new, friend_id: users(:bob)
                assert_equal users(:fred), assigns(:user_friendship).user
            end

            should "return 404 if no friend is found" do
                get :new, friend_id: 'invalid'
                assert_response :not_found
            end

            should "ask if you really want to friend the user" do
                get :new, friend_id: users(:bob)
                assert_match /Do you really want to friend #{users(:bob).full_name}?/, response.body
            end

        end
    end

    context "#create" do

        context "when not logged in" do

            should "redirect to the login page" do
                get :new
                assert_response :redirect
                assert_redirected_to login_path
            end
        end

        context "when logged in" do
            setup do
                sign_in users(:fred)
            end

            context "with no friend_id" do
                setup do
                    post :create
                end

                should "set the flash error message" do
                    assert !flash[:error].empty?
                end

                should "redirect to the root path" do
                    assert_response :redirect
                    assert_redirected_to root_path
                end
            end

            context "with a valid friend_id" do
                setup do
                    post :create, user_friendship: { friend_id: users(:mike) }
                end

                should "assign a friend object" do
                    assert assigns(:friend)
                    assert_equal users(:mike), assigns(:friend)
                end

                should "assign a user_friendship object" do
                    assert assigns(:user_friendship)
                    assert_equal users(:fred), assigns(:user_friendship).user
                    assert_equal users(:mike), assigns(:user_friendship).friend
                end

                should "create a friendship" do
                    assert users(:fred).friends.include?(users(:mike))
                end

                should "redirect to the profile page of the friend" do
                    assert_response :redirect
                    assert_redirected_to profile_path(users(:mike))
                end

                should "set the flash success message" do
                    assert flash[:success]
                    assert_equal "You are now friends with #{users(:mike).full_name}", flash[:success]
                end
            end
        end
    end
end
