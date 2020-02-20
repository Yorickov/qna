const answerHandler = (event) => {
  const { target } = event;
  if (!target.classList.contains('edit-answer-link')) return;

  event.preventDefault();

  const answerId = target.dataset.answerId;
  const form = document.querySelector(`form#edit-answer-${answerId}`);
  target.classList.add('hidden');
  form.classList.remove('hidden');
};

export default () => {
  const control = document.querySelector('.answers');
  if (control) {
    control.addEventListener('click', answerHandler.bind(this));
  }
};
