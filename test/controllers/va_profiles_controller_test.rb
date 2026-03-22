require "test_helper"

class VaProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @va_profile = va_profiles(:one)
  end

  test "should get index" do
    get va_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_va_profile_url
    assert_response :success
  end

  test "should create va_profile" do
    assert_difference("VaProfile.count") do
      post va_profiles_url, params: { va_profile: { budget: @va_profile.budget, niche: @va_profile.niche } }
    end

    assert_redirected_to va_profile_url(VaProfile.last)
  end

  test "should show va_profile" do
    get va_profile_url(@va_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_va_profile_url(@va_profile)
    assert_response :success
  end

  test "should update va_profile" do
    patch va_profile_url(@va_profile), params: { va_profile: { budget: @va_profile.budget, niche: @va_profile.niche } }
    assert_redirected_to va_profile_url(@va_profile)
  end

  test "should destroy va_profile" do
    assert_difference("VaProfile.count", -1) do
      delete va_profile_url(@va_profile)
    end

    assert_redirected_to va_profiles_url
  end
end
