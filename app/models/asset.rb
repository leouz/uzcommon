class Asset < ActiveRecord::Base
  attr_accessible :file, :group, :type
  mount_uploader :file, AssetUploader
end
