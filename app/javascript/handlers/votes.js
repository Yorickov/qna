const voteHandler = (event) => {
  const { target } = event;
  if (!target.parentNode.classList.contains('voting')) return;

  const { id, name, rating } = event.detail[0];

  const query = `[data-${name}-node-id="${id}"] .rating span`
  const elem = document.querySelector(query);
  elem.innerHTML = `${rating}`;
};

const errorsHandler = (event) => {
  const { message } = event.detail[0];

  const errorsNode = document.querySelector('.flash');
  const errorsHtml = `<p>${message}</p>`

  errorsNode.innerHTML = errorsHtml;
};

export default () => {
  const control = document.querySelector('main .container');
  if (control) {
    control.addEventListener('ajax:success', voteHandler.bind(this));
    control.addEventListener('ajax:error', errorsHandler.bind(this));
  }
};
