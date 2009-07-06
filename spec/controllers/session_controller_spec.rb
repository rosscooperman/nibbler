require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionController do
  before do
    @user = Factory(:user)

    # stub these urls as no routes exist in the skeleton app
    @new_session_url = '/session/new'
    SessionController.any_instance.stubs(:new_session_url).returns(@new_session_url)
    SessionController.any_instance.stubs(:signed_out_url).returns(@new_session_url)

    @forgot_password_url = '/forgot_password'
    SessionController.any_instance.stubs(:forgot_password_url).returns(@forgot_password_url)

    @root_url = '/users'
    SessionController.any_instance.stubs(:root_path).returns(@root_url)
    SessionController.any_instance.stubs(:root_url).returns(@root_url)

    User.stubs(:authenticate).returns(@user)
  end

  it "renders the new template with application layout" do
    get :new
    response.should render_template("new")
    response.should use_layout("application")
  end

  describe "#create" do
    def create
      post :create, :session => { :email => @user.email, :password => "foo", :remember_me => "1" }
    end

    it "attempts to authenticate" do
      SessionController.expects(:authenticate)
      create
    end

    describe "when login is successful" do
      before do
        SessionController.stubs(:logged_in?).returns(true)
      end
      it "remembers me and redirects" do
        create
        cookies[:auth_token].should == @user.remember_token
        response.should be_redirect
      end
    end

    describe "when login fails" do
      before do
        User.expects(:authenticate).returns(nil)
        SessionController.stubs(:logged_in?).returns(false)
      end
      it "flashes a message and renders new" do
        SessionController.expects(:flash_message)
        create
        response.should render_template(:new)
      end
    end
  end

  describe "#destroy" do
    def destroy
      delete :destroy
    end
    it "forgets me and flashes a success message" do
      SessionController.stubs(:logged_in?).returns(true)
      SessionController.expects(:forget_me!)
      SessionController.expects(:reset_session)
      SessionController.expects(:flash_message)
      destroy
      cookies[:auth_token].should be_nil
      assigns[:current_user].should be_nil
    end
  end

  describe "#forbidden" do
    it "renders successfully" do
      get :forbidden
      response.should be_success
    end
  end

  describe "#reset_password" do
    before do
      User.stubs(:find).returns(@user)
    end

    describe "GET requests" do
      def reset_password
        get :reset_password, :id => @user.id, :hash => @user.password_reset_hash
      end

      it "renders 'reset_password' template on get requests" do
        reset_password
        response.should render_template(:reset_password)
      end
    end

    describe "POST requests" do
      def reset_password
        post :reset_password, :id => @user.id, :hash => @user.password_reset_hash
      end
      it "updates the user's password, flashes a success message and redirects to root_url" do
        SessionController.expects(:flash_message).with(:reset_password, :success)
        @user.expects(:update_attributes).returns(true)
        reset_password
        response.should redirect_to(@root_url)
      end

      it "renders 'reset_password' on error" do
        @user.expects(:update_attributes).returns(false)
        reset_password
        response.should render_template(:reset_password)
      end
    end
  end

  describe "#forgot_password" do
    def forgot_password
      post :forgot_password, :user => { :email => @user.email }
    end

    describe "with a valid user email address" do
      before do
        @user.expects(:send_password_reset_email)
        User.expects(:find_by_email).returns(@user)
      end
      it "sends password reset email, flashes a success message and redirects" do
        @user.expects(:send_password_reset_email)
        SessionController.expects(:flash_message).with(:forgot_password, :success)
        forgot_password
        response.should redirect_to(@new_session_url)
      end
    end

    describe "without a valid user email address" do
      before do
        User.expects(:find_by_email).returns(nil)
      end
      it "flashes a problem message and redirects" do
        SessionController.expects(:flash_message).with(:forgot_password, :problem)
        forgot_password
        response.should redirect_to(@forgot_password_url)
      end
    end
  end
end

