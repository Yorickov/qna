class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'questions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # def follow
  #   stream_from 'questions'
  # end
end
