require 'points'
require 'scores'
require 'participations'
require 'position'
require 'bang'
require 'attribute_fallback'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  include Participations
  include Points
  include Scores
  include Position
  extend Bang
  extend AttributeFallback

  field 'login', :type => String
  field 'email', :type => String
  field 'token', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'participations', :type => Array, :default => []
  field 'points', :type => Integer, :default => 0
  field 'average_score', :type => Float, :default => 0.0
  field 'urls', :type => Hash, :default => {}
  field 'contributions', :type => Integer

  validates :login, :presence => true

  has_gravatar

  alias_method :to_param, :login

  bang :calculate_points => :points
  bang :calculate_average_score => :average_score
  fallback :name, :login

  def voted_entries(contest)
    contest.entries.select { |e| e.votes_from?(self) }
  end

end
