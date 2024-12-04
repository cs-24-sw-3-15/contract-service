class Contract < ApplicationRecord
  include AASM
  include SearchCop

  has_many :documents, dependent: :destroy
  accepts_nested_attributes_for :documents
  belongs_to :created_by, class_name: "User"
  belongs_to :label, optional: true

  belongs_to :supplier, optional: true
  belongs_to :affiliate, optional: true

  validates :supplier_id, presence: true, if: :approved?
  validates :affiliate_id, presence: true, if: :approved?
  validates :start_date, presence: true, if: :approved?

  validates :title, presence: true
  validates :documents, presence: true
  validate :end_date_not_after_start_date

  enum :status, [ :pending, :approved, :denied ]

  scope :active, -> { where(status: :approved).where(state: :active) }

  before_save :enqueue_if_possible, if: :will_save_change_to_start_date?
  before_save :activate_if_possible, if: :will_save_change_to_start_date?
  before_save :expire_if_possible, if: :will_save_change_to_end_date?

  after_save :try_schedule_activation, if: :saved_change_to_start_date?
  after_save :try_schedule_expiration, if: :saved_change_to_end_date?

  aasm column: :state do
    state :unscheduled, initial: true
    state :queued
    state :active
    state :expired

    event :enqueue do
      transitions from: :unscheduled, to: :queued, guards: :can_enqueue?
    end

    event :activate do
      transitions from: :queued, to: :active, guards: :can_activate?
    end

    event :expire do
      transitions from: :active, to: :expired, guards: :can_expire?
    end
  end

  search_scope :search do
    attributes :title, :status, :state, :start_date, :end_date
    attributes document: "documents.title"

    attributes all: [ "title", "documents.title" ]
    options :all, default: true
  end

  search_scope :advanced_search do
    attributes :title, :status, :state, :start_date, :end_date
    attributes document: "documents.title"
    attributes created_by: [ "created_by.name", "created_by.email" ]
    attributes supplier: "supplier.name"
    attributes supplier_number: "supplier.supplier_number"
    attributes affiliate: "affiliate.name"
    attributes tag: "label.tag"
    attributes label: "label.title"

    attributes all: [ "title", "documents.title" ]
    options :all, default: true
    options :tag, left_wildcard: false
  end

  private

  def try_schedule_activation
    return if start_date.nil?
    return if state != "queued"

    # TODO: Handle the case if start_date gets changed again while previous activation is still queued.
    ActivateContractJob.set(wait_until: start_date.to_datetime).perform_later(id)
  end

  def try_schedule_expiration
    return if end_date.nil?
    return if state != "active"

    # TODO: Handle the case if start_date gets changed again while previous activation is still queued.
    ExpireContractJob.set(wait_until: end_date.to_datetime).perform_later(id)
  end


  def enqueue_if_possible
    enqueue if may_enqueue?
  end

  def activate_if_possible
    activate if may_activate?
  end

  def expire_if_possible
    expire if may_expire?
  end

  def can_enqueue?
    return false if start_date.nil?

    true
  end

  def can_activate?
    return false if start_date.nil?
    return false if start_date > Date.today

    true
  end

  def can_expire?
    return false if end_date.nil?
    return false if end_date > Date.today

    true
  end

  def end_date_not_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date <= start_date
      errors.add(:expiration_date, "must be after the start date")
    end
  end
end
