module ApplicationHelper
  include ContentPackRails
  include ContentPackRails.init(pack_name: 'custom_pack')
end
