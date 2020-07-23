$(document).on('turbolinks:load', () => {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  });

  $('form.new-answer').on('ajax:success', (e) => {
    const xhr = e.detail[2];

    $('.answers').append(xhr.responseText);
    $('.answers-errors').html('');
  })
    .on('ajax:error', (e) => {
      const xhr = e.detail[2];

      $('.answers-errors').html(xhr.responseText);
    });
});
