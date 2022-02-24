class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  delegate :strip_tags, to: "ActionController::Base.helpers"
end
