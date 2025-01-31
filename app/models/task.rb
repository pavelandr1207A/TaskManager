class Task < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  validates :name, :author, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  state_machine initial: :new_task do
    state :in_development
    state :archived
    state :in_qa
    state :in_code_review
    state :ready_for_release
    state :released
    state :new_task

    event :archive do
      transition [:new_task, :released] => :archived
    end

    event :to_qa do
      transition in_development: :in_qa
    end

    event :to_dev do
      transition [:in_qa, :new_task, :in_code_review] => :in_development
    end

    event :to_review do
      transition in_qa: :in_code_review
    end

    event :prepare_to_release do
      transition in_code_review: :ready_for_release
    end

    event :release do
      transition ready_for_release: :released
    end
  end
end
