const questionHandler = (e) => {
  e.preventDefault();

  const { target } = e;
  const form = document.querySelector('.question-node .edit-question-form');

  target.classList.add('hidden');
  form.classList.remove('hidden');
};

export default () => {
  const control = document.querySelector('.edit-question-link');
  if (control) {
    control.addEventListener('click', questionHandler.bind(this));
  }
};
