class DbModification < ApplicationRecord
  STATUSES = %i[created moderating approved rejected rollbacked].freeze

  belongs_to :user
  #belongs_to :table_name, polymorphic: true
  #belongs_to :anime, class_name: 'Anime', foreign_key: :target_id, optional: true

  enumerize :status, in: STATUSES, default: :created

  after_create :apply_changes

  def apply_changes
    if status == :approved
      table_name.capitalize.singularize.constantize.find(target_id).update(row_name => new_data)
    end
  end
  def approve_changes
    table_name.capitalize.singularize.constantize.find(target_id).update(row_name => new_data)
    update(status: :approved)
  end
  def rollback_changes
    table_name.capitalize.singularize.constantize.find(target_id).update(row_name => old_data)
    update(status: :rollbacked)
  end

  def anime?
    table_name == 'Anime'
  end
end
