json.array!(@projects) do |project|
  json.extract! project, :id, :customer, :product, :platform, :user_id
  json.url project_url(project, format: :json)
end
