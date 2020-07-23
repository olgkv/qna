$(document).on('turbolinks:load', () => {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:success', (e) => {
    const answer = e.detail[0];

    $('.answers').append(`<p>${answer.body}</p>`);
    $('.answers-errors').html('');
  })
    .on('ajax:error', (e) => {
      const errors = e.detail[0];

      $.each(errors, (index, value) => {
        $('.answers-errors').append(`<p>${value}</p>`);
      });
    });
});
