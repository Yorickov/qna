import consumer from "./consumer"

consumer.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
  connected() {
    console.log('connected!');
  },

  disconnected() {
    console.log('disconnected!');
  },

  received(data) {
    this.addComment(data);
  },

  addComment(data) {
    console.log(data);
    if (gon.user_id == data.comment.user_id) return;

    const template = require('../views/comment.hbs');

    const htmlComment = template(data);

    const resourceType = data.comment.commentable_type;

    if (resourceType == 'Question') {
      const commentsNode = document.querySelector('.question-comments');
      commentsNode.insertAdjacentHTML('beforeEnd', htmlComment);
    } else {
      const answerNode = document.querySelector(`[data-answer-node-id="${data.comment.commentable_id}"]`);
      const commentsNode = answerNode.querySelector('.answer-comments');
      commentsNode.insertAdjacentHTML('beforeEnd', htmlComment);
    }
  }
});
