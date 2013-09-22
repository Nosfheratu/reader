Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Rails.logger

  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_SECRET

  provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET,
           {
             :scope => "userinfo.email,userinfo.profile,https://www.google.com/reader/api,plus.me",
             :approval_prompt => "auto",
             access_type: "offline"
           }
end