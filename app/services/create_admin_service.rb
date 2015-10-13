class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.admin!
      end


     user = User.find_or_create_by!(email: "joshua.montross@gmail.com") do |user|
        user.password = "613613jd"
        user.password_confirmation = "613613jd"
        user.role = "patron"
      end
  end

end
