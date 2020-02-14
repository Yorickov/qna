const questionHandler = (event) => {
  const { target } = event;
  if (!target.classList.contains('edit-question-link')) return;

  event.preventDefault();

  const form = document.querySelector('.question-node .edit-question-form');

  target.classList.add('hidden');
  form.classList.remove('hidden');
};

export default () => {
  const control = document.querySelector('.question-node');
  if (control) {
    control.addEventListener('click', questionHandler.bind(this));
  }
};
