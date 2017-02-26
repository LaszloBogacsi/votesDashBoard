class CampaignsController < ApplicationController

  def index
    votes = Vote.all
    c = Vote.select(:campaign).distinct
    c.each { |a| puts a.campaign }
    @campaigns = []
    votes.map { |vote| @campaigns << vote.campaign if !@campaigns.include?(vote.campaign)}
  end

  def show
    @campaign_votes = Vote.where(campaign: params[:id])
    @campaign_votes_valid = Vote.where(campaign: params[:id], validity: 'during')
    @campaign_votes_invalid = Vote.where(campaign: params[:id], validity: ['pre', 'post'])
    @choice_info = derive_data_to_show_from @campaign_votes_valid
  end


  private

  def derive_data_to_show_from campaign_votes
    choices = get_possible_choices(campaign_votes)
    create_info_for(choices, campaign_votes)
  end

  def get_possible_choices campaign_votes
    choices = []
    campaign_votes.map { |vote| choices << vote.choice if !choices.include?(vote.choice)}
    choices
  end

  def create_info_for (choices, campaign_votes)
    choice_info = []
    for name in choices do
      votes_per_choice = campaign_votes.select { |vote| vote.choice == name }
      percentage = (votes_per_choice.count * 100) / campaign_votes.count
      choice_info << {name: name, votes: votes_per_choice.count, percentage: percentage }
    end
    choice_info
  end

end