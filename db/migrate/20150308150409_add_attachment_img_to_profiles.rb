class AddAttachmentImgToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.attachment :img
    end
  end

  def self.down
    remove_attachment :profiles, :img
  end
end
