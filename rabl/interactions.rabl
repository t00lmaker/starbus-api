object :reputation
node(:numavaliacoes) { @reputation.num_interactions(@type) }
node(:reputation) { @reputation.media(@type)  }
child @interactions, :object_root => false do
  attributes :type_ => :type, :evaluation_value => :evaluation, :comment => :comment
  child :user, :object_root => false do
    attributes :name, :url_photo, :id_facebook
  end
end
