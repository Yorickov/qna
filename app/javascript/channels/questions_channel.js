import consumer from "./consumer";

consumer.subscriptions.create({ channel: 'QuestionsChannel' }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('connected!');
    // console.log(gon.question_id);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('disconnected!');
  },

  received(data) {
    console.log('received', data);
    // Called when there's incoming data on the websocket for this channel
    this.addQuestion(data);
  },

  addQuestion(html) {
    const questionList = document.querySelector('.questions');
    questionList.insertAdjacentHTML('beforeEnd', html);
  }
});
