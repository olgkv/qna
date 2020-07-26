$(document).on('turbolinks:load', () => {
  $('.votes-links')
    .on('ajax:success', (e) => {
      const data = e.detail[0];

      const { amount } = data;
      const { id } = data;
      const type = data.type.toLowerCase();

      const selector = `#${type}-votes-amount-${id}`;
      $(selector).text(`Votes: ${amount}`);
    })
    .on('ajax:error', (e) => {
      const errors = e.detail[0];

      $.each(errors, (index, value) => {
        $('.answers-errors').append(`<p>${value}</p>`);
      });
    });
});
