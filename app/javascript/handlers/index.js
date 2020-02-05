import answerHandler from './answers';
import questionHandler from './questions';

export default () => {
  document.addEventListener('turbolinks:load', () => {
    answerHandler();
    questionHandler();
  });
}
