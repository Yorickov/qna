module VotedPolicy
  def vote_up?
    user.present? && !author?
  end

  def vote_down?
    vote_up?
  end

  def vote_reset?
    vote_up?
  end
end
