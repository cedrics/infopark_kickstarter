class LoginPageController < CmsController
  def index
    @presenter = LoginPresenter.new(params[:login_presenter])

    if request.post? && @presenter.valid?
      login(@presenter, @obj)
    elsif request.delete?
      logout(@obj)
    end
  end

  private

  def login(presenter, obj)
    self.current_user = presenter.authenticate

    if current_user.logged_in?
      target = params[:return_to] || cms_path(obj.homepage)

      redirect_to(target, notice: t(:'flash.login.success'))
    end
  end

  def logout(obj)
    discard_user

    target = cms_path(obj.homepage)

    redirect_to(target, notice: t(:'flash.logout.success'))
  end
end