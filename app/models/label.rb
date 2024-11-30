class Label < ApplicationRecord
  has_ancestry
  has_many :contracts

  before_save :ensure_tag_path
  after_update :update_children_tags, if: :saved_change_to_tag?

  validates :title, presence: true
  validates :identifier, format: {
    with: /\A[A-Za-z0-9]{1,5}\z/,
    message: "must be a valid format, such as '05124', 'B', etc"
  }
  validates :color, format: {
    with: /\A#[0-9a-fA-F]{6}\z/,
    message: "only allows full html hex color, such as '#F4BB44'" }

  def stamp
    "#{tag} - #{title}"
  end

  def ensure_tag_path
    self.tag = (ancestors.pluck(:identifier) + [ identifier ]).join(".")
  end

  # TODO: Slow implementation, each depth adds another after_update.
  def update_children_tags
    paths = path.pluck(:identifier)
    children.each do |child|
      new_tag = (paths + [ child.identifier ]).join(".")
      child.update_columns(tag: new_tag)
    end
  end
end
