class PasswordsController < Devise::PasswordsController
  respond_to :json

  # PUT /resource/password
  def update

    set_minimum_password_length

    self.resource = resource_class.reset_password_by_token(resource_params)

    respond_to do |format|
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          msg = set_flash_message(:notice, flash_message) if is_flashing_format?
          res = { status: :ok, location: resource.as_json, notice: msg }
          format.html { render :edit }
          format.json { render json: res }
        else
          msg = set_flash_message(:notice, :updated_not_active) if is_flashing_format?
          res = { status: :ok, location: new_session_path(resource_name), notice: msg }
          format.html { render :edit }
          format.json { render json: res }
        end
      else
        format.html { render :edit }
        format.json { render json: resource.errors.full_messages, status: :unprocessable_entity }
      end
    end

  end

end
