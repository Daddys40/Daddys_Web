object @card

attributes :id
attributes :title
node(:created_at) { |u| u.created_at.to_s }
node(:updated_at) { |u| u.updated_at.to_s }
attributes :week
attributes :readed
attributes :content
node(:resources) { [] }