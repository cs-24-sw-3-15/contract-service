class Label < ApplicationRecord
  has_ancestry
  has_many :contracts

  enum :color_managed, [ :color_managed_unset, :color_manual, :color_managed ]

  before_save :ensure_tag, if: :will_save_change_to_identifier?
  after_update :update_children_tags, if: :saved_change_to_tag?
  before_destroy :push_up_tagged_contracts
  before_save :ensure_managed_color

  validates :title, presence: true
  validates :tag, uniqueness: true
  validates :identifier, format: {
    with: /\A[A-Za-z0-9]{1,5}\z/,
    message: "must be a valid format, such as '05124', 'B', etc"
  }
  validates :color, allow_blank: true, format: {
    with: /\A#[0-9a-fA-F]{6}\z/,
    message: "only allows full html hex color, such as '#F4BB44'" }

  def push_up_tagged_contracts
    Contract.where(label_id: id).update_all label_id: parent&.id
  end

  # TODO: Not yet triggered on parent update.
  def ensure_managed_color
    return if color == :color_manual

    if parent
      derived_color = Color::RGB.from_html(parent.color).darken_by(80).html
      if color.blank? || color == "#000000" || color == derived_color || color_managed == :color_managed
        self.color_managed = :color_managed
        self.color = derived_color
      else
        self.color_managed = :color_manual
      end
    else
      self.color_managed = :color_manual
    end
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
