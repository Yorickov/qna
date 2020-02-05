const answerHandler = (e) => {
  const { target } = e;
  if (!target.classList.contains('edit-answer-link')) return;

  e.preventDefault();

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
