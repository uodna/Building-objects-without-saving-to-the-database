class Book < ActiveRecord::Base
  cattr_accessor :form_steps do
    [:name, :author]
  end

  attr_accessor :form_step

  validates :name, presence: true, if: -> { required_for_step?(:name) }
  validates :author, presence: true, if: -> { required_for_step?(:author) }

  def required_for_step?(step)
    return true if form_step.nil?
    return true if self.form_steps.index(step) <= self.form_steps.index(form_step)
  end
end
