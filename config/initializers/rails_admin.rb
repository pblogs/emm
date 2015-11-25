RailsAdmin.config do |config|
  config.included_models = %W(User)
  config.total_columns_width = 1400

  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  config.actions do
    dashboard
    index
    edit
    delete
  end

  config.model 'User' do
    list do
      field :full_name
      field :email
      %W(created_at last_sign_in_at).each do |field|
        field field.to_sym do
          strftime_format "%Y-%m-%d"
          label 'Last visit' if field == 'last_sign_in_at'
          label 'Registered' if field == 'created_at'
        end
      end

      %W(albums photos videos texts relationships).each do |field|
        field "#{field}_count" do
          label field.camelize
          sortable true
        end
      end
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :birthday
    end
  end
end
