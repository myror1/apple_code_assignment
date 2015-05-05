json.array!(@people) do |person|
  json.extract! person, :id, :first_name, :last_name, :email, :admin, :slug, :validated, :handle, :team
  json.url person_url(person, format: :json)
end
