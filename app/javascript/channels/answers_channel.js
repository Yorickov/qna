import consumer from "./consumer"

consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
  connected() {
    console.log('connected!');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    this.addAnswer(data);
  },

  addAnswer(data) {
    if (gon.user_id == data.answer.user_id) return;

    const template = require('../views/answer.hbs');

    const answersNode = document.querySelector('.answers');
    data.author_check = gon.user_id == gon.question_user_id;

    answersNode.insertAdjacentHTML('beforeEnd', template(data));
    answersNode.insertAdjacentHTML('afterEnd', data.form);
  }
});
