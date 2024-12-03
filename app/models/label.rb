class Label < ApplicationRecord
  has_ancestry
  has_many :contracts

  before_save :ensure_tag, if: :will_save_change_to_identifier?
  after_update :update_children_tags, if: :saved_change_to_tag?
  before_destroy :push_up_tagged_contracts

  validates :title, presence: true
  validates :tag, uniqueness: true
  validates :identifier, format: {
    with: /\A[A-Za-z0-9]{1,5}\z/,
    message: "must be a valid format, such as '05124', 'B', etc"
  }
  validates :color, format: {
    with: /\A#[0-9a-fA-F]{6}\z/,
    message: "only allows full html hex color, such as '#F4BB44'" }

  def push_up_tagged_contracts
    Contract.where(label_id: id).update_all label_id: parent&.id
  end

  def tag
    # Dont show internal `^`.
    super[1..] if super
  end

  def stamp
    "#{tag} - #{title}"
  end

  def ensure_tag
    # HACK: `^` used to denote the start of a tag, allows `REPLACE` function
    # inside the database to update its children in one query.
    self.tag = "^" + (ancestors.pluck(:identifier) + [ identifier ]).join(".")
  end

  def update_children_tags
    old_tag = attribute_before_last_save(:tag)

    Label.update_all("tag = REPLACE(tag, #{
      ActiveRecord::Base.connection.quote(old_tag + ".")
    }, #{
      ActiveRecord::Base.connection.quote(tag + ".")
    })")
  end
end
