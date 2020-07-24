$(document).on('turbolinks:load', () => {
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  });
});
