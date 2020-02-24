import answerHandler from './answers';
import questionHandler from './questions';
import voteHandler from './votes';

export default () => {
  document.addEventListener('turbolinks:load', () => {
    answerHandler();
    questionHandler();
    voteHandler();
  });
}
